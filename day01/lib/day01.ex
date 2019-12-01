defmodule Day01 do
  def part1 do
    "../data/input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(fn line -> line |> String.trim_trailing |> String.to_integer |> fuel_required end)
    |> Enum.sum
  end



  def fuel_required(mass) do
    mass
    |> div(3)
    |> Kernel.-(2)
  end
end
