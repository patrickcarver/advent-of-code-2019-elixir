defmodule Day08 do
  def run(:part1) do
    starting_data()
    |> part1()
  end

  def run(:part2) do
    starting_data()
    |> part2()
    |> IO.puts()
  end

  def part1(data) do
    data
    |> layers()
    |> fewest_zeros()
    |> nonzero_product()
  end

  def part2(data) do
    data
    |> layers()
    |> overlay()
    |> format()
  end

  def starting_data() do
    %{
      pixels: pixels_from_file("priv/input.txt"),
      width: 25,
      height: 6
    }
  end

  def pixels_from_file(file_name) do
    file_name
    |> File.read!()
    |> String.codepoints()
  end

  def layers(%{pixels: pixels, width: width, height: height}) do
    layers = Enum.chunk_every(pixels, height * width)
    %{layers: layers, width: width}
  end

  def fewest_zeros(%{layers: layers}) do
    Enum.min_by(layers, &(count(&1, "0")))
  end

  def nonzero_product(pixels) do
    count(pixels, "1") * count(pixels, "2")
  end

  def count(pixels, value) do
    Enum.count(pixels, &(&1 == value))
  end

  def overlay(%{layers: layers, width: width}) do
    layer =
      Enum.reduce(layers, fn bottom, top ->
        bottom
        |> Enum.zip(top)
        |> Enum.map(fn
          {bottom_layer, "2"} -> bottom_layer
          {_bottom_layer, top_layer} -> top_layer
        end)
      end)

    %{layer: layer, width: width}
  end

  def format(%{layer: layer, width: width}) do
    layer
    |> Enum.map(fn
      "0" -> " "
      "1" -> "█"
    end)
    |> Enum.chunk_every(width)
    |> Enum.join("\n")
  end
end
