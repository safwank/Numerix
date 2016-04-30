defmodule Numerix.Distance do
  alias Statix.Correlation

  # Calculates the Pearson's distance between two vectors.
  def pearson(vector1, vector2), do: 1.0 - Correlation.pearson(vector1, vector2)

end
