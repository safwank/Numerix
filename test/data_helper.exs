defmodule DataHelper do

  def read(dataset) do
    "test/resources/data/#{dataset}.dat"
    |> File.read!
    |> String.split("\n")
    |> Stream.drop_while(fn line -> line != "Data: Y" end)
    |> Stream.drop(2)
    |> parse_data
  end

  defp parse_data(lines) do
    lines
    |> Stream.map(&String.strip/1)
    |> Stream.map(&Float.parse/1)
    |> Stream.filter(fn x -> x != :error end)
    |> Stream.map(&elem(&1, 0))
  end

end
