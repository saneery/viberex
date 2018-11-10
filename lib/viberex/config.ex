defmodule Viberex.Config do
  @viber_url "https://chatapi.viber.com/pa"

  def viber_api(), do: @viber_url

  def auth_token() do
    Application.get_env(:viberex, :auth_token)
  end
end
