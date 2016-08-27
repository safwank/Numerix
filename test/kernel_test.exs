defmodule Numerix.KernelTest do
  use ExUnit.Case, async: false
  use ExCheck
  import ListHelper

  alias Numerix.Kernel

  property :rbf_is_between_0_and_1 do
    for_all {xs, ys} in such_that({xxs, yys} in {non_empty(list(number)), non_empty(list(number))}
      when length(xxs) > 1 and length(yys) > 1) do

      {xs, ys} = equalize_length(xs, ys)

      Kernel.rbf(xs, ys) |> between?(0, 1)
    end
  end
end
