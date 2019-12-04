defmodule Day04 do
  def part1 do
    125730..579381
    |> Stream.map(&Integer.digits/1)
    |> Stream.reject(fn digits ->
      digits == Enum.dedup(digits)
    end)
    |> Stream.filter(fn digits ->
      digits == Enum.sort(digits)
    end)
    |> Enum.to_list()
    |> length
  end

  def part2 do
    :todo
  end
end
