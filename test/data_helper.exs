defmodule DataHelper do
  def read(dataset) do
    lines = "test/resources/data/#{dataset}.dat" |> File.stream!()
    %{std_dev: parse_std_dev(lines), data: parse_data(lines)}
  end

  defp parse_std_dev(lines) do
    lines
    |> Stream.filter(fn line -> String.contains?(line, "Sample Standard Deviation") end)
    |> Enum.at(0)
    |> String.split(":")
    |> List.last()
    |> String.trim()
    |> Float.parse()
    |> elem(0)
  end

  defp parse_data(lines) do
    lines
    |> Stream.drop_while(fn line -> line != "Data: Y\n" end)
    |> Stream.drop(2)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&Float.parse/1)
    |> Stream.filter(fn x -> x != :error end)
    |> Stream.map(&elem(&1, 0))
  end
end
