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
        "commit": ["credo --strict", "espec"]
      ],
      default_task: "commit"
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:credo, "~> 0.3.13", only: :test},
      {:espec, "~> 0.8.18", only: :test}
    ]
  end
end
