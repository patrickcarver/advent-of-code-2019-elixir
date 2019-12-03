defmodule Day03 do
  def part1() do
    load()
    |> coordinates()
    |> intersections()
    |> distance_of_closest_intersection_to_origin()
  end

  def part2() do
    paths = load()

    # need intersections
    intersections = paths |> coordinates() |> intersections() |> MapSet.to_list()

    [first, second] = paths
    |> Enum.map(fn path ->
      path
      |> create_segments()
      |> List.flatten()
      |> Enum.dedup()
      |> Enum.with_index()
      |> Enum.into(%{})
    end)

    first_distances = Enum.map(intersections, fn coord -> Map.get(first, coord) end)
    second_distances = Enum.map(intersections, fn coord -> Map.get(second, coord) end)
    Enum.zip(first_distances, second_distances) |> Enum.map(fn {f, s} -> f + s end) |> Enum.min
  end

  defp intersections([first, second]) do
    MapSet.intersection(first, second)
  end

  defp coordinates(paths) do
    Enum.map(paths, fn path ->
      path
      |> create_segments()
      |> to_mapset()
    end)
  end

  defp to_mapset(segments) do
    segments
    |> List.flatten()
    |> MapSet.new()
    |> MapSet.delete({0, 0})
  end

  defp create_segments(path) do
    path
    |> Enum.map_reduce({0, 0}, &create_segment/2)
    |> elem(0)
  end

  defp create_segment("R" <> num, {start_x, start_y}) do
    len = start_x + String.to_integer(num)
    segment = for x <- start_x..len, do: {x, start_y}
    {segment, {len, start_y}}
  end

  defp create_segment("L" <> num, {start_x, start_y}) do
    len = start_x - String.to_integer(num)
    segment = for x <- start_x..len, do: {x, start_y}
    {segment, {len, start_y}}
  end

  defp create_segment("U" <> num, {start_x, start_y}) do
    len = start_y + String.to_integer(num)
    segment = for y <- start_y..len, do: {start_x, y}
    {segment, {start_x, len}}
  end

  defp create_segment("D" <> num, {start_x, start_y}) do
    len = start_y - String.to_integer(num)
    segment = for y <- start_y..len, do: {start_x, y}
    {segment, {start_x, len}}
  end

  defp distance_of_closest_intersection_to_origin(intersections) do
    Enum.reduce(intersections, fn coord, acc ->
      coord
      |> distance_from_origin()
      |> min(acc)
    end)
  end

  defp distance_from_origin({x, y}) do
    abs(x) + abs(y)
  end

  defp load() do
    "../data/input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(& String.split(&1, ","))
  end
end
