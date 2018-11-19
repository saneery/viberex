defmodule Viberex.Plug do
  @moduledoc """
  Plug that handle message from Viber.

  ## Usage

  Add to your router
  ```elixir
  scope "/webhook" do
    forward "/viber",
      Viberex.Plug,
      handler: &MyApp.Handler.handle/1
  end
  ```

  And define handler. The `handle` function must return `:noreply` or `{:reply, message}`
  if callback wait response, e.g. [welcome message](https://viber.github.io/docs/api/rest-bot-api/#sending-a-welcome-message).
  ```elixir
  defmodule MyApp.Handler do
    def handle(message) do
      IO.inspect(message)
      :noreply
    end
  end
  ```
  """
  @behaviour Plug
  import Plug.Conn
  require Logger

  def init(options), do: options

  def call(%{request_path: path} = conn, %{path: endpoint})
  when path != endpoint and endpoint != nil do
    send_resp(conn, 500, "")
  end

  def call(conn, opts) do
    conn
    |> fetch_query_params()
    |> get_params()
    |> handle(Keyword.get(opts, :handler))
    |> response(conn)
  end

  defp get_params(%{params: params} = conn) do
    if is_map(params) and map_size(params) > 0 do
      {:ok, params}
    else
      conn
      |> read_body
      |> decode_body
    end
  end

  defp decode_body({:ok, body, _conn}) do
    case Poison.decode(body) do
      {:ok, _params} = ok ->
        ok
      _error ->
        Logger.error("Invalid message came: #{body}")
        :noreply
    end
  end

  defp handle({:ok, params}, handler) when handler != nil do
    handler.(params)
  end

  defp handle(_, _), do: :noreply

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

end
