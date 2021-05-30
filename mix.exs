defmodule Numerix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :numerix,
      name: "Numerix",
      description:
        "A collection of useful mathematical functions in Elixir with a slant towards statistics, linear algebra and machine learning",
      version: "0.7.0",
      elixir: "~> 1.9",
      source_url: "https://github.com/safwank/Numerix",
      deps: deps(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        credo: :test,
        "coveralls.html": :test,
        commit: :test
      ],
      aliases: [
        commit: ["dialyzer --ignore-exit-status", "credo --strict", "coveralls.html --trace"]
      ],
      default_task: "commit"
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:flow, "~> 1.1.0"},
      {:credo, "~> 1.5.0", only: [:dev, :test]},
      {:dialyxir, "~> 1.1.0", only: [:dev, :test]},
      {:excoveralls, "~> 0.14.0", only: :test},
      {:stream_data, "~> 0.5.0", only: :test},
      {:ex_doc, "~> 0.24.0", only: :dev},
      {:earmark, "~> 1.4.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Safwan Kamarrudin"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/safwank/Numerix"}
    ]
  end
end
