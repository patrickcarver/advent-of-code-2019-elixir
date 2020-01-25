defmodule Day08 do
  def run(:part1) do
    starting_data() |> part1()
  end

  def run(:part2) do
    starting_data() |> part2() |> IO.puts()
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

  defp layers(%{pixels: pixels, width: width, height: height}) do
    layers = Enum.chunk_every(pixels, height * width)
    %{layers: layers, width: width}
  end

  defp overlay(%{layers: layers, width: width}) do
    layer =
      Enum.reduce(layers, fn bottom, top ->
        bottom
        |> Enum.zip(top)
        |> Enum.map(fn
          {_b, "0"} -> "0"
          {_b, "1"} -> "1"
          {b, _t} -> b
        end)
      end)

    %{layer: layer, width: width}
  end

  defp format(%{layer: layer, width: width}) do
    translate_pixel = select_translate(IO.ANSI.enabled?())

    layer
    |> Enum.map(translate_pixel)
    |> Enum.chunk_every(width)
    |> Enum.join("\n")
  end

  defp select_translate(true) do
    fn
      "0" -> IO.ANSI.black() <> "█"
      "1" -> IO.ANSI.white() <> "█"
    end
  end

  defp select_translate(false) do
    fn
      "0" -> " "
      "1" -> "█"
    end
  end

  defp fewest_zeros(%{layers: layers}) do
    Enum.min_by(layers, fn pixels -> count(pixels, "0") end)
  end

  defp nonzero_product(pixels) do
    count(pixels, "1") * count(pixels, "2")
  end

  defp count(pixels, value) do
    Enum.count(pixels, &(&1 == value))
  end

  defp pixels_from_file(file_name) do
    file_name
    |> File.read!()
    |> String.codepoints()
  end
end
