defmodule Numerix.WindowTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  import ListHelper

  alias Numerix.Window

  test "gaussian is correct for specific examples" do
    [
      {0.0, 1.0},
      {0.1, 0.99501247919268232},
      {1.0, 0.60653065971263342},
      {3.0, 0.01110899653824231}
    ]
    |> Enum.each(fn {width, expected} ->
      assert_in_delta(Window.gaussian(width), expected, 0.0000000001)
    end)
  end

  property "gaussian is between 0 and 1" do
    check all(
            width <- float(),
            sigma <- float(),
            sigma = abs(sigma)
          ) do
      assert Window.gaussian(width, sigma) |> between?(0, 1)
    end
  end
end
