# Numerix

A collection of (potentially) useful mathematical functions. At the moment it has a number of distance and correlation functions. The plan is to implement other special functions, statistics, probability distributions, maybe even machine learning algorithms.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `numerix` to your list of dependencies in `mix.exs`:

        def deps do
          [{:numerix, "~> 0.0.1"}]
        end

  2. Ensure `numerix` is started before your application:

        def application do
          [applications: [:numerix]]
        end
