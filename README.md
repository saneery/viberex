# Viberex

[![Hex.pm](https://img.shields.io/hexpm/v/viberex.svg)](https://hex.pm/packages/viberex)
[![API Docs](https://img.shields.io/badge/api-docs-green.svg?style=flat)](http://hexdocs.pm/viberex/)

**Viber REST API wrapper in Elixir**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `viberex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:viberex, "~> 0.2.1"}
  ]
end
```

## Configuration
In `config\config.exs`, add your Viber authentication token
```elixir
config :viberex,
  auth_token: "token"
```

## Usage

Viber doesn't provide long pooling, thus you have to set webhook.
You can use [ngrok](https://ngrok.com/) to test application in development environment.

```elixir
Viberex.set_webhook("https://my-url.com")
```

To handle callbacks from Viber you can use [Viberex.Server](https://hexdocs.pm/viberex/Viberex.Server.html) or [Viberex.Plug](https://hexdocs.pm/viberex/Viberex.Plug.html)

Refer to [viberex documentation](https://hexdocs.pm/viberex) and [Viber API documentation](https://viber.github.io/docs/api/rest-bot-api) for more details
