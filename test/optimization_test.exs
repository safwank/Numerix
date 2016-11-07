defmodule Numerix.OptimizationTest do
  use ExUnit.Case, async: false
  use ExCheck

  import Numerix.Optimization

  @tag iterations: 10
  property "genetic optimization returns the solution with the lowest cost" do
    cost_fun = fn(x) -> Enum.sum(x) end

    for_all {x, y} in such_that({xx, yy} in {non_neg_integer, non_neg_integer} when xx < yy) do
      domain = [x..y] |> Stream.cycle |> Enum.take(10)

      genetic(domain, cost_fun) == [x] |> Stream.cycle |> Enum.take(10)
    end
  end
end
