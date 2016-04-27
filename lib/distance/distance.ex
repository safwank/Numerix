defmodule Statix.Distance do

  def pearson([], _), do: 0
  def pearson(_, []), do: 0
  def pearson(vector1, vector2) do
    sum1 = vector1 |> Enum.sum
    sum2 = vector2 |> Enum.sum

    sum_of_squares1 = vector1 |> square |> Enum.sum
    sum_of_squares2 = vector2 |> square |> Enum.sum

    sum_of_products = fn x, y -> x * y end
                      |> :lists.zipwith(vector1, vector2)
                      |> Enum.sum

    size = length(vector1)
    num = sum_of_products - (sum1 * sum2 / size)
    density = den(sum_of_squares1, sum1, size) * den(sum_of_squares2, sum2, size)
              |> :math.sqrt

    case density do
      0.0 -> 0.0
      _   -> 1 - num / density
    end
  end

  defp square(vector) do
    vector |> Enum.map(&:math.pow(&1, 2))
  end

  defp den(a, b, size) do
    a - :math.pow(b, 2) / size
  end

end
