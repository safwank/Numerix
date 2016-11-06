defmodule Numerix.OptimizationTest do
  use ExUnit.Case, async: false
  use ExCheck

  import Numerix.Optimization

  test "genetic optimization is correct for a specific example" do
    domain = [0..9] |> Stream.cycle |> Enum.take(10)
    cost_fun = fn(x) -> Enum.sum(x) end

    assert genetic(domain, cost_fun) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  end
end
