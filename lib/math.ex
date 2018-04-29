defmodule Numerix.Math do
  @moduledoc """
  Common mathematical functions.
  """

  @doc """
  Calculates the nth root of a number.
  """
  @spec nth_root(number, integer, float) :: float
  def nth_root(x, n, precision \\ 1.0e-5)
  def nth_root(x, _n, _precision) when x == 0, do: 0.0
  def nth_root(_x, n, _precision) when n == 0, do: 0.0

  def nth_root(x, n, precision) do
    f = fn prev -> ((n - 1) * prev + x / :math.pow(prev, n - 1)) / n end
    fixed_point(f, x, precision, f.(x))
  end

  defp fixed_point(_, guess, tolerance, next) when abs(guess - next) < tolerance, do: next
  defp fixed_point(f, _, tolerance, next), do: fixed_point(f, next, tolerance, f.(next))
end
