defmodule Viberex.MixProject do
  use Mix.Project

  def project do
    [
      app: :viberex,
      version: "0.2.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Viberex",
      source_url: "https://github.com/saneery/viberex",
      description: "Viber REST API Wrapper written in Elixir",
      package: package()
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
      {:plug_cowboy, "~> 1.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["saneery"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/saneery/viberex"}
    ]
  end
end
