defmodule Day04 do
  alias Day04.Rules

  def part1 do
    total_matching_passwords(125730..579381, &Rules.part1/1)
  end

  def part2 do
    total_matching_passwords(125730..579381, &Rules.part2/1)
  end

  defp total_matching_passwords(range, rules) do
    range
    |> Stream.map(&Integer.digits/1)
    |> rules.()
    |> Enum.to_list()
    |> length
  end
end
