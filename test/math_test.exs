defmodule Numerix.MathTest do
  use ExUnit.Case, async: true
  use ExCheck
  alias Numerix.Math

  property "nth root is the reverse of power" do
    for_all {x, n} in such_that({xx, nn} in {int(), int()} when xx > 0 && nn > 0) do
      x |> Math.nth_root(n) |> :math.pow(n) |> Float.round() == x
    end
  end
end
