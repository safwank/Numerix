defmodule PropertyHelper do
  def matrix_of(stream_data, size) do
    stream_data
    |> StreamData.list_of(length: size)
    |> StreamData.list_of(length: size)
  end
end
