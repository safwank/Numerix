defmodule Numerix.Statistics do
  @moduledoc """
  Common statistical functions.
  """

  @doc """
  Calculates the average of a list of numbers.
  """
  @spec mean([number]) :: number
  def mean([]), do: 0
  def mean(xs) do
    Enum.sum(xs) / length(xs)
  end

  @doc """
  Returns the middle value in a list of numbers.
  """
  @spec median([number]) :: number
  def median([]), do: 0
  def median(xs) do
    middle_index = round((length(xs) / 2)) - 1
    xs |> Enum.sort |> Enum.at(middle_index)
  end

  @doc """
  Calculates the most frequent value(s) in a list.
  """
  @spec mode([number]) :: [number] | nil
  def mode([]), do: nil
  def mode(xs) do
    if xs |> repeated? do
      xs
      |> Enum.reduce(%{}, fn(x, acc) -> acc |> Map.update(x, 1, &(&1 + 1)) end)
      |> Enum.sort(fn {_val1, count1}, {_val2, count2} -> count1 > count2 end)
      |> Enum.reduce_while({}, fn({val, count}, acc) ->
        case acc do
          {}                      -> {:cont, {count, [val]}}
          {c, vs} when c == count -> {:cont, {count, [val | vs]}}
          _                       -> {:halt, acc}
        end
      end)
      |> elem(1)
    else
      nil
    end
  end

  @doc """
  Calculates the difference between the largest and smallest values in a list.
  """
  @spec range([number]) :: number
  def range([]), do: 0
  def range(xs) do
    {minimum, maximum} = Enum.min_max(xs)
    maximum - minimum
  end

  defp repeated?(xs) do
    Enum.uniq(xs) != xs
  end

end
