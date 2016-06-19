defmodule Numerix.WindowFunctionsTest do
  use ExUnit.Case, async: false
  use ExCheck
  alias Numerix.WindowFunctions

  test :gaussian_is_correct_for_specific_examples do
    [
      {0.0, 1.0},
      {0.1, 0.99501247919268232},
      {1.0, 0.60653065971263342},
      {3.0, 0.01110899653824231}
    ]
    |> Enum.each(fn {width, expected} ->
      assert_in_delta(WindowFunctions.gaussian(width), expected, 0.0000000001)
    end)
  end

  property :gaussian_is_between_0_and_1 do
    for_all {width, sigma} in {number, non_neg_integer} do
      sigma = sigma / 100
      g = WindowFunctions.gaussian(width, sigma)

      g >= 0 and g <= 1
    end
  end

end
