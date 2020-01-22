defmodule Day08 do
  def part1() do
    "../priv/input.txt"
    |> load()
    |> layers(%{width: 25, height: 6})
    |> fewest_zeros()
    |> multiply_ones_and_twos()
  end

  def part2() do
    "../priv/input.txt"
    |> load()
    |> layers(%{width: 25, height: 6})
  end

  def fewest_zeros(layers) do
    layers
    |> Enum.map(fn layer ->
      layer
      |> List.flatten()
      |> Enum.reduce(%{}, fn digit, acc ->
        Map.update(acc, digit, 1, & &1 + 1)
      end)
    end)
    |> Enum.min_by(fn %{"0" => zeros} -> zeros end)
  end

  def multiply_ones_and_twos(%{"1" => ones, "2" => twos}) do
    ones * twos
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
