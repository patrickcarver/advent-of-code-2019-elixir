defmodule Day01 do
  def part1 do
    module_masses()
    |> Stream.map(&fuel_required/1)
    |> Enum.sum
  end

  def part2 do
    module_masses()
    |> Stream.map(fn mass -> recurse(mass, 0) end)
    |> Enum.sum
  end

  def recurse(mass, acc) do
    fuel = fuel_required(mass)

    if fuel > 0 do
      recurse(fuel, acc + fuel)
    else
      acc
    end
  end

  def module_masses do
    "../data/input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(fn line -> line |> String.trim_trailing |> String.to_integer end)
  end

  def fuel_required(mass) do
    mass
    |> div(3)
    |> Kernel.-(2)
  end
end
