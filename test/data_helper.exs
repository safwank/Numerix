defmodule DataHelper do

  def read(dataset) do
    lines = "test/resources/data/#{dataset}.dat" |> File.read! |> String.split("\n")
    %{std_dev: parse_std_dev(lines), data: parse_data(lines) }
  end

  defp parse_std_dev(lines) do
    lines
    |> Enum.find(fn line -> String.contains?(line, "Sample Standard Deviation") end)
    |> String.split(":")
    |> List.last
    |> String.strip
    |> Float.parse
    |> elem(0)
  end

  defp parse_data(lines) do
    lines
    |> Stream.drop_while(fn line -> line != "Data: Y" end)
    |> Stream.drop(2)
    |> Stream.map(&String.strip/1)
    |> Stream.map(&Float.parse/1)
    |> Stream.filter(fn x -> x != :error end)
    |> Stream.map(&elem(&1, 0))
  end

end
