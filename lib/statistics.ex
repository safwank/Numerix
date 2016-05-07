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
  Calculates the most frequent value in a list.
  """
  @spec mode([number]) :: number | nil
  def mode([]), do: nil
  def mode(xs) do
    most_frequent = xs
                    |> Enum.sort
                    |> Enum.chunk_by(&(&1))
                    |> Enum.max_by(&length/1)

    case length(most_frequent) do
      1 -> nil
      _ -> hd(most_frequent)
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

end
