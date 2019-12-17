defmodule Day10 do
  def part1 do
    "../data/example1.txt"
    |> load()
    |> coordinates()
    |> count()
  #  |> most_lines_of_sight()
  end

  def most_lines_of_sight(counts) do
    counts
    |> Map.values()
    |> Enum.max()
  end

  def count(asteroids) do
    pairs = combinations(asteroids, 2)
  #  existing = MapSet.new(asteroids)

 #   Enum.reduce(pairs, %{}, fn [{x1, y1} = first, {x2, y2} = second], acc ->

 #     acc
 #   end)
  end

  def combinations(list, num)
  def combinations(_list, 0), do: [[]]
  def combinations(list = [], _num), do: list
  def combinations([head | tail], num) do
    Enum.map(combinations(tail, num - 1), & [head | &1]) ++ combinations(tail, num)
  end

  def coordinates(stream) do
    stream
    |> Enum.reduce({[], 0}, fn row, {coordinates, row_index} ->
      new_coordinates =
        row
        |> String.codepoints()
        |> Enum.reduce({[], 0}, fn
          ".", {spaces, column_index} -> {spaces, column_index + 1}
          "#", {spaces, column_index} -> {[{column_index, row_index} | spaces ], column_index + 1}
        end)
        |> elem(0)
        |> Kernel.++(coordinates)

        {new_coordinates, row_index + 1}
    end)
    |> elem(0)
  end

  def load(file_name) do
    file_name
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
  end
end
