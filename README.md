# Viberex

**Viber REST API wrapper in Elixir**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `viberex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:viberex, "~> 0.1.0"}
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
Viberex.set_webhook("https://my-url.com/viber/webhook")
```

To handle callbacks from Viber you can use [Viberex.Server](https://hexdocs.pm/viberex/doc/Viberex.Server.html)

Refer to [viberex documentation](https://hexdocs.pm/viberex) and [Viber API documentation](https://viber.github.io/docs/api/rest-bot-api) for more details
