defmodule Day04 do
  def part1 do
    125730..579381
    |> Stream.map(&Integer.digits/1)
    |> Stream.filter(fn digits ->
      digits != Enum.dedup(digits)
    end)
    |> Stream.filter(fn digits ->
      digits == Enum.sort(digits)
    end)
    |> Enum.to_list()
    |> length
  end

  def part2 do
    125730..579381
    |> Stream.map(&Integer.digits/1)
    |> Stream.filter(fn digits ->
      process(digits)
    end)
    |> Stream.filter(fn digits ->
      digits == Enum.sort(digits)
    end)
    |> Enum.to_list()
    |> length
  end

  def process(digits) do
    Enum.reduce(digits, [{0,0}], fn digit, [{last_digit, count} | rest] = acc ->
      if digit == last_digit do
        [{digit, count + 1} | rest]
      else
        [{digit, 1} | acc]
      end
    end) |> Enum.any?(fn {_digit, count} -> count == 2 end)
  end
end
