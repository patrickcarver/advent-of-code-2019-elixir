defmodule Day08 do
  def part1 do
    data()
    |> layers()
    |> layer_with_fewest_zeroes()
    |> product_of_ones_and_twos_in_layer()
  end

  def part2 do
    data()
    |> layers()
    |> overlay()
    |> display()
  end

  def data() do
    %{digits: load(), dimensions: {25, 6}}
  end

  def display(layer) do
    layer
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn 0 -> " "; 1 -> "█" end)
      |> Enum.join()
      |> Kernel.<>("\n")
    end)
    |> Enum.join()
    |> IO.puts()
  end

  def overlay(layers) do
    layers
    |> Enum.reverse()
    |> Enum.reduce(fn current_layer, previous_layer ->
        overlay_layer(current_layer, previous_layer, [])
    end)
  end

  def overlay_layer([], [], new_layer) do
    Enum.reverse(new_layer)
  end

  def overlay_layer([current_row | current_rest], [previous_row | previous_rest], new_layer) do
    new_row = overlay_row(current_row, previous_row)
    new_layer = [new_row | new_layer]
    overlay_layer(current_rest, previous_rest, new_layer)
  end

  def overlay_row(current_row, previous_row) do
    Enum.zip(current_row, previous_row) |> Enum.map(&overlay_pixel/1)
  end

  # 0 = black
  # 1 = white
  # 2 = transparent

  def overlay_pixel({0, 1}), do: 0
  def overlay_pixel({1, 0}), do: 1
  def overlay_pixel({2, x}), do: x
  def overlay_pixel({x, 2}), do: x
  def overlay_pixel({x, x}), do: x

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
      total_zeroes = total_zeroes(layer)
      {layer, total_zeroes}
    end)
    |> Enum.min_by(fn {_layer, zeroes} -> zeroes end)
    |> elem(0)
  end

  def layers(%{digits: digits, dimensions: {width, height}}) do
    digits
    |> Enum.chunk_every(width)
    |> Enum.chunk_every(height)
  end

  def total_zeroes(layer) do
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
