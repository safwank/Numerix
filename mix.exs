defmodule Numerix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :numerix,
      name: "Numerix",
      description: "A collection of useful mathematical functions in Elixir with a slant towards statistics, linear algebra and machine learning",
      version: "0.4.2",
      elixir: "~> 1.3",
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
      {:credo, "~> 0.6", only: [:dev, :test]},
      {:dialyxir, "~> 0.4", only: [:dev, :test]},
      {:excoveralls, "~> 0.6", only: :test},
      {:excheck, "~> 0.5", only: :test},
      {:triq, github: "triqng/triq", only: :test},
      {:ex_doc, "~> 0.14", only: :dev},
      {:earmark, "~> 1.1", only: :dev},
      {:flow, "~> 0.11"}
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
