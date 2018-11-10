defmodule Viberex do
  @moduledoc """
  Documentation for Viberex.
  """
  import Viberex.API

  @doc """
  Set webhook
  """
  def set_webhook(url), do: request("set_webhook", %{url: url})

  @doc """
  Send message
  """
  def send_message(msg) do
    request("send_message", msg)
  end

end
