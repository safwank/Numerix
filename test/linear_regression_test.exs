defmodule Numerix.LinearRegressionTest do
  use ExUnit.Case, async: false

  import Numerix.LinearRegression

  test "least squares fit is correct for a specific example" do
    assert fit([1.3, 2.1, 3.7, 4.2], [2.2, 5.8, 10.2, 11.8]) == {-1.5225601452564685, 3.193826600090785}
  end
end
