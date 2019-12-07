defmodule Day06 do
  def part1 do
    "../data/input.txt"
    |> load()
    |> build_data()
    |> total_orbits()
  end

  def part2 do
    "../data/input.txt"
    |> load()
    |> build_data()
    |> minimum_transfers()
  end

  def minimum_transfers(%{list: _list, map: map}) do
    mp1 = map |> path_to_COM("YOU", []) |> MapSet.new()
    mp2 = map |> path_to_COM("SAN", []) |> MapSet.new()

    d1 = MapSet.difference(mp1, mp2) |> Enum.to_list() |> length
    d2 = MapSet.difference(mp2, mp1) |> Enum.to_list() |> length

    d1 + d2
  end

  def path_to_COM(_map, "COM", path) do
    path
  end

  def path_to_COM(map, object, path) do
    left = Map.get(map, object)
    path_to_COM(map, left, [left | path])
  end

  def total_orbits(%{list: list, map: map}) do
    Enum.reduce(list, 0, fn object, total ->
      count(object, map, total)
    end)
  end

  def count("COM", _map, total) do
    total
  end

  def count(object, map, total) do
    left = Map.get(map, object)
    count(left, map, total + 1)
  end

  def build_data(stream) do
    stream
    |> Stream.map(fn line -> String.split(line, ")") end)
    |> Enum.reduce(%{list: [], map: %{}}, fn [left, right], %{list: list, map: map} ->
      list = [right | list]
      map = Map.put(map, right, left)
      %{list: list, map: map}
    end)
  end

  def load(file_name) do
    file_name
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
  end
end
