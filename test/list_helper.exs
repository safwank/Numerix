defmodule ListHelper do

  def non_empty_lists_of_equal_length?([], _), do: false
  def non_empty_lists_of_equal_length?(_, []), do: false
  def non_empty_lists_of_equal_length?(xs, ys) do
    length(xs) == length(ys)
  end

  def unique?([]), do: false
  def unique?(xs) do
    xs |> Enum.uniq |> length == length(xs)
  end

end
