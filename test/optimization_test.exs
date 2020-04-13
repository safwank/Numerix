defmodule Numerix.OptimizationTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  import Numerix.Optimization

  property "genetic optimization returns the solution with the lowest cost" do
    cost_fun = fn xs -> Enum.sum(xs) end

    check all(
            numbers <- list_of(integer(0..255), min_length: 2),
            min = Enum.min(numbers),
            count = Enum.count(numbers),
            max_runs: 10
          ) do
      domain = [numbers] |> Stream.cycle() |> Enum.take(count)

      assert genetic(domain, cost_fun, iterations: 1000) ==
               [min] |> Stream.cycle() |> Enum.take(count)
    end
  end
end
