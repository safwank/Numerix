defmodule Numerix.OptimizationTest do
  use ExUnit.Case, async: true
  use ExCheck

  import Numerix.Optimization

  @tag iterations: 10
  property "genetic optimization returns the solution with the lowest cost" do
    cost_fun = fn(xs) -> Enum.sum(xs) end

    for_all {min, max, count} in such_that({min_, max_, _} in
      {non_neg_integer(), non_neg_integer(), non_neg_integer()} when min_ < max_) do

      domain = [min..max] |> Stream.cycle |> Enum.take(count)

      genetic(domain, cost_fun) == [min] |> Stream.cycle |> Enum.take(count)
    end
  end
end
