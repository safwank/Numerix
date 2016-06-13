defmodule Numerix.SpecialFunctionsTest do
  use ExUnit.Case, async: false
  use ExCheck
  alias Numerix.SpecialFunctions

  test :logit_is_nil_when_p_is_invalid do
    refute SpecialFunctions.logit(-0.1)
    refute SpecialFunctions.logit(1.1)
  end

  test :logit_is_correct_for_specific_examples do
    [
      {0.000010, -11.512915464920228103874353849992239636376994324587},
      {0.001000, -6.9067547786485535272274487616830597875179908939086},
      {0.100000, -2.1972245773362193134015514347727700402304323440139},
      {0.500000, 0.0},
      {0.900000, 2.1972245773362195801634726294284168954491240598975},
      {0.999000, 6.9067547786485526081487245019905638981131702804661},
      {0.999990, 11.512915464924779098232747799811946290419057060965}
    ]
    |> Enum.each(fn {p, expected} ->
      assert SpecialFunctions.logit(p) == expected
    end)
  end

  property :logistic_is_the_inverse_of_logit do
    for_all x in int(1, 999) do
      p = x / 1000
      logit = SpecialFunctions.logit(p)

      assert_in_delta(SpecialFunctions.logistic(logit), p, 0.001)
    end
  end

end
