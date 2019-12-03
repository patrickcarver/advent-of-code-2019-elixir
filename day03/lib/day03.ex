defmodule Day03 do
  def part1() do
    [first, second] = load() |> Enum.map(fn wire ->
      Enum.map_reduce(wire, {0, 0},
        fn
          "R" <> num, {start_x, start_y} ->
            len = start_x + String.to_integer(num)
            segment = for x <- start_x..len, do: {x, start_y}
            {segment, {len, start_y}}
          "L" <> num, {start_x, start_y} ->
            len = start_x - String.to_integer(num)
            segment = for x <- start_x..len, do: {x, start_y}
            {segment, {len, start_y}}
          "U" <> num, {start_x, start_y} ->
            len = start_y + String.to_integer(num)
            segment = for y <- start_y..len, do: {start_x, y}
            {segment, {start_x, len}}
          "D" <> num, {start_x, start_y} ->
            len = start_y - String.to_integer(num)
            segment = for y <- start_y..len, do: {start_x, y}
            {segment, {start_x, len}}
        end) |> elem(0) |> List.flatten |> MapSet.new |> MapSet.delete({0, 0})
    end)

    MapSet.intersection(first, second)
    |> Enum.reduce(fn {x, y}, acc ->
      distance = abs(x) + abs(y)
      min(distance, acc)
    end)
  end

  defp load() do
    "../data/input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(& String.split(&1, ","))
  end
end
