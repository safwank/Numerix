defmodule Numerix.KernelTest do
  use ExUnit.Case, async: true
  use ExCheck
  import ListHelper

  alias Numerix.Kernel

  property "rbf is between 0 and 1" do
    for_all {xs, ys} in such_that({xxs, yys} in {non_empty(list(number())), non_empty(list(number()))}
      when length(xxs) > 1 and length(yys) > 1) do

      {xs, ys} = equalize_length(xs, ys)

      Kernel.rbf(xs, ys) |> between?(0, 1)
    end
  end
end
