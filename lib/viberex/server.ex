defmodule Viberex.Server do
  @moduledoc """
  Server that handle callbacks from Viber.
  All available events you can see here [Callbacks](https://viber.github.io/docs/api/rest-bot-api/#callbacks)

  ## Usage

  Write callbacks handler. The `handle_callback` function must return `:noreply` or `{:reply, message}`
  if callback wait response, e.g. [welcome message](https://viber.github.io/docs/api/rest-bot-api/#sending-a-welcome-message).
  ```elixir
  defmodule MyApp.Handler do
    use Viberex.Server

    def handle_callback(%{"event" => "conversation_started"}) do
      welcome_message = %{
        text: "Hi!",
        type: "text"
      }
      {:reply, welcome_message}
    end

    def handle_callback(_), do: :noreply
  end
  ```

  Add the handler to supervisor
  ```elixir
  defmodule MyApp.Application do
    use Application

    def start(_type, _args) do
      import Supervisor.Spec

      # Set args `reqest_path` and `port`
      children = [
        worker(MyApp.Handler, ["/webhook/viber", 8000])
      ]

      opts = [strategy: :one_for_one, name: MyApp.Supervisor]
      Supervisor.start_link(children, opts)
    end
  end
  ```
  """

  defmacro __using__(_) do
    quote do
      def start_link(path \\ "/", port \\ 4000) do
        Plug.Adapters.Cowboy.http(
          Viberex.Plug,
          [path: path, handler: &__MODULE__.handle_callback/1],
          port: port
        )
      end

      def handle_callback(body), do: :noreply

      defoverridable handle_callback: 1
    end
  end

end
