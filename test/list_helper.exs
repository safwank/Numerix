defmodule ListHelper do
  def non_empty_lists_of_equal_length?(xs, ys) do
    length(xs) == length(ys)
  end

  def unique?([]), do: false

  def unique?(xs) do
    xs |> Enum.uniq() |> length == length(xs)
  end

  def equalize_length(xs, ys) do
    min_length = Enum.min([length(xs), length(ys)])
    {Enum.take(xs, min_length), Enum.take(ys, min_length)}
  end

  def between?(value, minimum, maximum) do
    value >= minimum and value <= maximum
  end
end
