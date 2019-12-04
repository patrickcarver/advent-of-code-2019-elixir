defmodule Day03 do
  def part1() do
    load()
    |> intersections()
    |> distance_of_closest_intersection_to_origin()
  end

  def part2() do
    paths = load()
    intersections = intersections(paths)

    fewest_combined_steps(paths, intersections)
  end

  defp fewest_combined_steps(paths, intersections) do
    paths
    |> Enum.map(fn path ->
      path
      |> create_segments()
      |> Enum.dedup()
      |> Enum.with_index()
      |> Enum.into(%{})
      |> steps_of_intersection(intersections)
    end)
    |> Enum.zip()
    |> Enum.map(fn {f, s} -> f + s end)
    |> Enum.min()
  end

  defp steps_of_intersection(indexed_segments, intersections) do
    Enum.map(intersections, fn coord -> Map.get(indexed_segments, coord) end)
  end

  defp intersections(paths) do
    Enum.map(paths, fn path ->
      path
      |> create_segments()
      |> to_mapset()
    end)
    |> (fn [first, second] -> MapSet.intersection(first, second) end).()
    |> MapSet.to_list()
  end

  defp to_mapset(segments) do
    segments
    |> MapSet.new()
    |> MapSet.delete({0, 0})
  end

  defp create_segments(path) do
    path
    |> Enum.map_reduce({0, 0}, &create_one_segment_with_endpoint/2)
    |> elem(0)
    |> List.flatten()
  end

  defp create_one_segment_with_endpoint(<<direction::binary-size(1), amount::binary>>, coord) do
    {orientation, operation} = direction_functions(direction)
    amount = String.to_integer(amount)

    apply(orientation, [operation, amount, coord])
  end

  defp direction_functions(direction) do
    case direction do
      "R" -> {&horizontal/3, &Kernel.+/2}
      "L" -> {&horizontal/3, &Kernel.-/2}
      "U" -> {&vertical/3, &Kernel.+/2}
      "D" -> {&vertical/3, &Kernel.-/2}
    end
  end

  defp horizontal(operation, steps, {start_x, start_y}) do
    len = apply(operation, [start_x, steps])
    segment = for x <- start_x..len, do: {x, start_y}
    {segment, {len, start_y}}
  end

  defp vertical(operation, steps, {start_x, start_y}) do
    len = apply(operation, [start_y, steps])
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
