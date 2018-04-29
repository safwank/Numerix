defmodule Numerix.LinearAlgebraTest do
  use ExUnit.Case, async: true

  import Numerix.LinearAlgebra

  test "dot product is correct for a specific example" do
    assert dot([1, 2, 3], [4, 5, 6]) == 32
  end

  test "norm of a normal list (for coverage)" do
    assert norm(2, [1, 2, 3]) == 3.7416573867739458
  end
end
