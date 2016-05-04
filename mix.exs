defmodule Numerix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :numerix,
      name: "Numerix",
      description: "A collection of (potentially) useful mathematical functions",
      version: "0.0.1",
      elixir: "~> 1.2",
      source_url: "https://github.com/safwank/Numerix",
      deps: deps,
      package: package,
      preferred_cli_env: [
        credo: :test,
        espec: :test,
        commit: :test
      ],
      aliases: [
        "commit": ["dialyzer", "credo --strict", "test --trace", "espec --trace"]
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
      {:dialyxir, "~> 0.3.3", only: [:dev, :test]},
      {:espec, "~> 0.8.18", only: :test},
      {:excheck, "~> 0.3.3", only: :test},
      {:triq, github: "krestenkrab/triq", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Safwan Kamarrudin"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/safwank/Numerix"},
    ]
  end
end
