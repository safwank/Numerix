defmodule Numerix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :numerix,
      version: "0.0.1",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      preferred_cli_env: [
        credo: :test,
        espec: :test,
        commit: :test
      ],
      aliases: [
        "commit": ["dialyzer", "credo --strict", "espec"]
      ],
      default_task: "commit"
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:credo, "~> 0.3.13", only: :test},
      {:espec, "~> 0.8.18", only: :test},
      {:dialyxir, "~> 0.3.3", only: [:dev, :test]}
    ]
  end
end
