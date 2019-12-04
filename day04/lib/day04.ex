defmodule Day04 do
  def part1 do
    process(125730..579381, &at_least_two_adjacent_matching_digits/1)
  end

  def part2 do
    process(125730..579381, &two_adjacent_matching_digits_not_in_larger_match/1)
  end

  defp process(range, matching_rule) do
    range
    |> Stream.map(&Integer.digits/1)
    |> Stream.filter(matching_rule)
    |> Stream.filter(&in_ascending_order/1)
    |> Enum.to_list()
    |> length
  end

  def in_ascending_order(digits) do
    Enum.sort(digits) == digits
  end

  def at_least_two_adjacent_matching_digits(digits) do
    digits != Enum.dedup(digits)
  end

  def two_adjacent_matching_digits_not_in_larger_match(digits) do
    Enum.reduce(digits, [{0,0}], fn digit, [{last_digit, count} | rest] = acc ->
      if digit == last_digit do
        [{digit, count + 1} | rest]
      else
        [{digit, 1} | acc]
      end
    end) |> Enum.any?(fn {_digit, count} -> count == 2 end)
  end
end
