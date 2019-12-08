defmodule Day08 do
  def part1 do
    dimensions = {25, 6}

    load()
    |> layers(dimensions)
    |> layer_with_fewest_zeroes()
    |> product_of_ones_and_twos_in_layer()
  end

  def product_of_ones_and_twos_in_layer(layer) do
    layer
    |> Enum.reduce([0, 0], fn row, [total_ones, total_twos] ->
      ones = Enum.count(row, & &1 == 1)
      twos = Enum.count(row, & &1 == 2)
      [total_ones + ones, total_twos + twos]
    end)
    |> Enum.reduce(fn x, acc -> x * acc end)
  end

  def layer_with_fewest_zeroes(layers) do
    layers
    |> Enum.map(fn layer ->
      zeroes = zeroes(layer)
      {layer, zeroes}
    end)
    |> Enum.min_by(fn {_layer, zeroes} -> zeroes end)
    |> elem(0)
  end

  def layers(list, {width, height}) do
    list
    |> Enum.chunk_every(width)
    |> Enum.chunk_every(height)
  end

  def zeroes(layer) do
    layer
    |> Enum.map(fn row -> Enum.count(row, & &1 == 0)  end)
    |> Enum.sum()
  end

  def load() do
    "../data/input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> hd()
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
  end
end
