defmodule Day08 do
  def part1() do
    "../priv/input.txt"
    |> load()
    |> layers(%{width: 25, height: 6})
  end

  def layers(input, %{width: width, height: height}) do
    input
    |> String.codepoints()
    |> Enum.chunk_every(width)
    |> Enum.chunk_every(height)
  end

  def load(file_name) do
    file_name
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> hd()
  end
end
