defmodule Day05 do
  alias Day05.Program
  def part1 do
    load()
    |> Program.initialize_memory()
  end

  def part2 do
    :todo
  end

  defp load do
    "../data/input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> hd()
  end
end
