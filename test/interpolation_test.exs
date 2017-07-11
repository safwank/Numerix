defmodule Numerix.InterpolationTest do
  use ExUnit.Case, async: false

  test "Interpolation works good for specyfic example" do
    res = [{5,150}, {7,392}, {11, 1452}, {13, 2366}, {17, 5202}]
    |> Numerix.Interpolation.lagrange(9)
    assert Float.floor(res, 2) == 809.99
  end

  test "Lagrange helper method returns proper product" do
    assert Numerix.Interpolation.l(3, [{5,150}, {7,392}, {11, 1452}, {13, 2366}, {17, 5202}], 9)
    |> Float.floor(2) == -0.34
    assert Numerix.Interpolation.l(0, [{5,150}, {7,392}, {11, 1452}, {13, 2366}, {17, 5202}], 9)
    |> Float.floor(2) == -0.12
    assert Numerix.Interpolation.l(1, [{5,150}, {7,392}, {11, 1452}, {13, 2366}, {17, 5202}], 9)
    |> Float.floor(2) == 0.53
  end

end
