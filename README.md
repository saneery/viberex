# Viberex

[![Hex.pm](https://img.shields.io/hexpm/v/viberex.svg)](https://hex.pm/packages/viberex)
[![API Docs](https://img.shields.io/badge/api-docs-green.svg?style=flat)](http://hexdocs.pm/viberex/)

**Viber REST API wrapper in Elixir**

## Installation

Viberex can be installed
by adding `viberex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:viberex, "~> 0.2.1"}
  ]
end
```

## Configuration

In `config\config.exs`, add your Viber authentication token. This token you can take from [Viber Admin Panel](https://partners.viber.com/).
```elixir
config :viberex,
  auth_token: "token"
```

## Usage

Viber doesn’t provide long-polling for getting updates, instead, Viber uses webhooks and callbacks. Since a webhook requires a public server, you can use [ngrok](https://ngrok.com/) to publish a local server.

Viberex has a behavior module [Viberex.Server](https://hexdocs.pm/viberex/Viberex.Server.html) for implementing the webhook server. By using it, you can handle callbacks from Viber.
In your module, you need to define a function with a name `handle_callback/1`. This function must return `{:reply, message}` if the callback waits for a response (e.g. [welcome message](https://viber.github.io/docs/api/rest-bot-api/#sending-a-welcome-message)), and `:noreply` if it doesn’t.

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

Add server to application’s supervisor tree with endpoint path and port:
```elixir
defmodule MyApp.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(MyApp.Handler, ["/webhook/viber", 8000])
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

After starting the project, just set webhook's url
```elixir
$ iex -S mix
iex(1)> Viberex.set_webhook("https://my-url.com/webhook/viber")
```

All avaible API methods you can find [here](https://hexdocs.pm/viberex/Viberex.html)

## Using with Phoenix
Viberex has a [plug](https://hexdocs.pm/viberex/Viberex.Plug.html) that you can use in your Phoenix project. Add forward in your router and just define `MyPhoenix.Handler` module with `handle_callback/1` function
```elixir
defmodule MyPhoenixWeb.Router do
  use MyPhoenixWeb, :router

  forward "webhook/viber",
    Viberex.Plug,
    handler: &MyPhoenix.Handler.handle_callback/1
end
```
---
Refer to [viberex documentation](https://hexdocs.pm/viberex) and [Viber API documentation](https://viber.github.io/docs/api/rest-bot-api) for more details
