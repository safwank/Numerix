defmodule Numerix.KernelTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  import ListHelper

  alias Numerix.Kernel

  describe "rbf/2" do
    property "is between 0 and 1" do
      check all(
              xs <- list_of(float(), min_length: 2),
              ys <- list_of(float(), min_length: 2)
            ) do
        assert Kernel.rbf(xs, ys) |> between?(0, 1)
      end
    end
  end
end
