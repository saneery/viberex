defmodule Viberex.MixProject do
  use Mix.Project

  def project do
    [
      app: :viberex,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Viberex",
      source_url: "https://github.com/saneery/viberex"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:poison, "~> 3.1"},
      {:plug_cowboy, "~> 2.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end
