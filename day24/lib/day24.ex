defmodule Day24 do
  @spec part1 :: [any]
  def part1()do
    tiles = tiles_from_file("../data/input.txt")
    previous_layouts = MapSet.new()
    minute(tiles, previous_layouts, 1)
  end

  def minute(tiles, previous_layouts, minute) do
    new_tiles = new_tiles(tiles)

    if MapSet.member?(previous_layouts, new_tiles) do
      #for {key, value} <- new_tiles, value == "#", into: %{}, do: {key, value}
      new_tiles
      |> Enum.filter(fn {_coord, tile} -> tile == "#" end)
      |> Enum.map(fn {coord, _tile} ->
        biodiversity_rating(coord)
      end)
      |> Enum.sum()
    else
      minute(
        new_tiles,
        MapSet.put(previous_layouts, new_tiles),
        minute + 1
      )
    end
  end

  def biodiversity_rating({y, x}) do
    exponent = x + (5 * y)
    trunc(:math.pow(2, exponent))
  end

  def new_tiles(tiles) do
    Enum.reduce(tiles, %{}, fn {{x, y}, tile}, acc ->
      neighbors = neighbors(tiles, x, y)
      bug_count = neighbors |> Enum.count(& &1 == "#")
      new_tile = update_tile(tile, bug_count)
      Map.put(acc, {x, y}, new_tile)
    end)
  end

  def update_tile(".", bug_count) when bug_count in [1,2] do
    "#"
  end

  def update_tile(".", _bug_count) do
    "."
  end

  def update_tile("#", bug_count) when bug_count == 1 do
    "#"
  end

  def update_tile("#", _bug_count) do
    "."
  end
  def neighbors(tiles, x, y) do
    [
      {x, y-1},
      {x-1, y},
      {x+1, y},
      {x, y+1}
    ]
    |> Enum.map(& Map.get(tiles, &1, "."))
  end

  @spec tiles_from_file(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | char,
              binary | []
            )
        ) :: any
  def tiles_from_file(file_name) do
    file_name
    |> load()
    |> parse()
  end

  def parse(stream) do
    stream
    |> Stream.map(fn line ->
      line
      |> String.codepoints()
      |> Enum.with_index()
    end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row_list, row_index}, acc ->
      Enum.reduce(row_list, %{}, fn {tile, col_index}, row ->
        Map.put(row, {row_index, col_index}, tile)
      end)
      |> Map.merge(acc)
    end)
  end

  def load(file_name) do
    file_name
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
  end
end
