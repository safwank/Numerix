defmodule Numerix.Correlation do

  @doc "Calculates the Pearson correlation coefficient between two vectors."
  @spec pearson([number], [number]) :: float | :error
  def pearson([], _), do: :error
  def pearson(_, []), do: :error
  def pearson(vector1, vector2) do
    sum1 = vector1 |> Enum.sum
    sum2 = vector2 |> Enum.sum

    sum_of_squares1 = vector1 |> square |> Enum.sum
    sum_of_squares2 = vector2 |> square |> Enum.sum

    sum_of_products = vector1
                      |> Stream.zip(vector2)
                      |> Stream.map(fn {x, y} -> x * y end)
                      |> Enum.sum

    size = length(vector1)
    num = sum_of_products - (sum1 * sum2 / size)
    density = :math.sqrt((sum_of_squares1 - :math.pow(sum1, 2) / size) * (sum_of_squares2 - :math.pow(sum2, 2) / size))

    case density do
      0.0 -> 0.0
      _   -> num / density
    end
  end

  defp square(vector) do
    vector |> Enum.map(&:math.pow(&1, 2))
  end

end
