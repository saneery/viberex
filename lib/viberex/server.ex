defmodule Viberex.Server do

  defmacro __using__(_) do
    quote do
      import Plug.Conn
      require Logger

      def start_link() do
        Plug.Adapters.Cowboy.http(__MODULE__, [])
      end

      def init(options), do: options

      def call(conn, _opts) do
        conn
        |> read_body()
        |> decode_body()
        |> response(conn)
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
