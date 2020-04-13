defmodule Numerix.MathTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Numerix.Math

  describe "nth_root/2" do
    property "is the reverse of power" do
      check all(
              x <- integer(1..1_000_000),
              n <- integer(1..50)
            ) do
        assert Math.nth_root(x, n) |> :math.pow(n) |> Float.round() == x
      end
    end
  end
end
