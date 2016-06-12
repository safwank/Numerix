defmodule Numerix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :numerix,
      name: "Numerix",
      description: "A collection of (potentially) useful mathematical functions",
      version: "0.0.4",
      elixir: "~> 1.2",
      source_url: "https://github.com/safwank/Numerix",
      deps: deps,
      package: package,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "credo": :test,
        "coveralls.html": :test,
        "commit": :test
      ],
      aliases: [
        "commit": ["dialyzer", "credo --strict", "coveralls.html --trace"]
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
      {:excoveralls, "~> 0.5.4", only: :test},
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
