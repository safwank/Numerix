defmodule Numerix.SpecialTest do
  use ExUnit.Case, async: true
  use ExCheck

  import ListHelper

  alias Numerix.Special

  test "logit is nil when p is invalid" do
    refute Special.logit(-0.1)
    refute Special.logit(1.1)
  end

  test "logit is correct for specific examples" do
    [
      {0.000000, :negative_infinity},
      {0.000010, -11.512915464920228103874353849992239636376994324587},
      {0.001000, -6.9067547786485535272274487616830597875179908939086},
      {0.100000, -2.1972245773362193134015514347727700402304323440139},
      {0.500000, 0.0},
      {0.900000, 2.1972245773362195801634726294284168954491240598975},
      {0.999000, 6.9067547786485526081487245019905638981131702804661},
      {0.999990, 11.512915464924779098232747799811946290419057060965},
      {1.000000, :infinity}
    ]
    |> Enum.each(fn {p, expected} ->
      assert Special.logit(p) == expected
    end)
  end

  property "logistic is the inverse of logit" do
    for_all x in int(0, 1000) do
      p = x / 1000
      logit = Special.logit(p)

      if is_atom(logit) do
        Special.logistic(logit) == p
      else
        assert_in_delta(Special.logistic(logit), p, 0.001)
      end
    end
  end

  property "logistic is between 0 and 1" do
    for_all x in number() do
      Special.logistic(x) |> between?(0, 1)
    end
  end
end
