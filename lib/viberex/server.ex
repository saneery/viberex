defmodule Viberex.Server do
  @moduledoc """
  Server that handle callbacks from Viber.
  All available events you can see here [Callbacks](https://viber.github.io/docs/api/rest-bot-api/#callbacks)

  ## Usage

  Write callbacks handler
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
      import Plug.Conn
      require Logger

      def start_link(path \\ "/", port \\ 4000) do
        Plug.Adapters.Cowboy.http(__MODULE__, [path: path], port: port)
      end

      def init(options), do: options

      def call(conn, opts) do
        if opts[:path] == conn.request_path do
          conn
          |> read_body()
          |> decode_body()
          |> response(conn)
        else
          send_resp(conn, 404, "not found")
        end
      end

      defp decode_body({:ok, body, _conn}) do
        case Poison.decode(body) do
          {:ok, params} ->
            handle_callback(params)
          error ->
            Logger.error("Invalid message came: #{body}")
            :noreply
        end
      end

      defp response({:reply, data}, conn) when is_map(data) do
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(200, Poison.encode!(data))
      end
      defp response(:noreply, conn) do
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(200, "")
      end

      def handle_callback(body), do: :noreply

      defoverridable handle_callback: 1
    end
  end

end
