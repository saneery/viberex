defmodule Viberex do
  @moduledoc """
  Provides access to Viber REST API.

  ## Reference
  https://viber.github.io/docs/api/rest-bot-api
  """
  import Viberex.API

  @doc """
  Setting webhook for receiving callbacks and user messages from Viber.
  Removing the webhook is done by calling with an empty string.
  """
  @spec set_webhook(url :: String.t) :: {:ok, map} | {:error, any}
  def set_webhook(url), do: request("set_webhook", %{url: url})

  @doc """
  Sending message to users who subscribe to the public account
  """
  @spec send_message(message :: map) :: {:ok, map} | {:error, any}
  def send_message(message), do: request("send_message", message)

  @doc """
  The broadcast_message API allows accounts to send messages to multiple Viber users who subscribe to the account
  """
  @spec broadcast_message(message :: map) :: {:ok, map} | {:error, any}
  def broadcast_message(message) do
    request("broadcast_message", message)
  end

  @doc """
  Get public account details
  """
  @spec get_account_info() :: {:ok, map} | {:error, any}
  def get_account_info() do
    request("get_account_info")
  end

  @doc """
  The get_user_details request will fetch the details of a specific Viber user based on his unique user ID.
  """
  @spec get_user_details(user_id :: String.t) :: {:ok, map} | {:error, any}
  def get_user_details(user_id) do
    request("get_user_details", %{id: user_id})
  end

  @doc """
  The get_online request will fetch the online status of a given subscribed account members
  """
  @spec get_online(user_ids :: List.t) :: {:ok, map} | {:error, any}
  def get_online(user_ids) do
    request("get_online", %{ids: user_ids})
  end

  @doc """
  The post API allows the Public Account owner to post a message in the Public Account’s public chat.
  """
  @spec post(message :: map) :: {:ok, map} | {:error, any}
  def post(message), do: request("post", message)

end
