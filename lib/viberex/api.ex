defmodule Viberex.API do
  @moduledoc """
  Work with Viber API
  """
  alias Viberex.{Parser, Config}

  def request(method, options \\ []) do
    method
    |> build_url
    |> HTTPoison.post(build_request(options), headers())
    |> response(method)
  end

  defp response(response, method) do
    case decode_response(response) do
      {:ok, result} ->
        {:ok, Parser.parse_result(result, method)}

      {:error, _} = error ->
        error
    end
  end

  defp decode_response(response) do
    with {:ok, %HTTPoison.Response{body: body}} <- response,
         {:ok, %{result: result}} <- Poison.decode(body, keys: :atoms),
         do: {:ok, result}
  end

  defp build_url(method) do
    Config.viber_api() <> "/" <> method
  end

  defp build_request(params) do
    params =
      params
      |> Enum.filter(fn {_, v} -> v end)
      |> Enum.into(%{})
      |> Poison.encode!()

    params
  end

  defp headers() do
    [
      "Content-Type": "application/json",
      "X-Viber-Auth-Token": Config.auth_token
    ]
  end
end
