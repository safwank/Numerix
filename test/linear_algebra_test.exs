defmodule Numerix.LinearAlgebraTest do
  use ExUnit.Case, async: false

  import Numerix.LinearAlgebra

  test "dot product is correct for a specific example" do
    assert [1, 2, 3] |> dot_product([4, 5, 6]) == 32
  end
end
