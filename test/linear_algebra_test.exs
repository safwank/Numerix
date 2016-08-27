defmodule Numerix.LinearAlgebraTest do
  use ExUnit.Case, async: false

  alias Numerix.LinearAlgebra

  test "dot product is correct for a specific example" do
    [1, 2, 3]
    |> LinearAlgebra.dot_product([4, 5, 6]) == 32
  end
end
