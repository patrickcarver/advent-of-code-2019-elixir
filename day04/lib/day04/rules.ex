defmodule Day04.Rules do
  def part1(stream) do
    stream
    |> Stream.filter(&at_least_two_adjacent_matching_digits/1)
    |> Stream.filter(&in_ascending_order/1)
  end

  def part2(stream) do
    stream
    |> Stream.filter(&two_adjacent_matching_digits_not_in_larger_match/1)
    |> Stream.filter(&in_ascending_order/1)
  end

  def in_ascending_order(digits) do
    Enum.sort(digits) == digits
  end

  def at_least_two_adjacent_matching_digits(digits) do
    digits != Enum.dedup(digits)
  end

  def two_adjacent_matching_digits_not_in_larger_match(digits) do
    digits
    |> count_digits()
    |> any_with_count_of_2?()
  end

  defp count_digits(digits) do
    Enum.reduce(digits, [{0,0}], fn digit, [{last_digit, count} | rest] = acc ->
      if digit == last_digit do
        [{digit, count + 1} | rest]
      else
        [{digit, 1} | acc]
      end
    end)
  end

  defp any_with_count_of_2?(list) do
    Enum.any?(list, fn {_digit, count} -> count == 2 end)
  end
end
