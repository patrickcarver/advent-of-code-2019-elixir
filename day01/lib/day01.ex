defmodule Day01 do
  def part1 do
    module_masses()
    |> Stream.map(&fuel_required/1)
    |> Enum.sum
  end

  def part2 do
    module_masses()
    |> Stream.map(&recurse/1)
    |> Enum.sum()
  end

  def part2_with_stream_iterate do
    module_masses()
    |> Stream.map(&iterate/1)
    |> Enum.sum()
  end

  def recurse(mass, acc \\ 0) do
    fuel = fuel_required(mass)

    if fuel > 0 do
      recurse(fuel, acc + fuel)
    else
      acc
    end
  end

  def iterate(mass) do
    mass
    |> Stream.iterate(&fuel_required/1)
    |> Enum.take_while(& &1 > 0)
    |> tl() # the list will have the initial mass
    |> Enum.sum()
  end

  def fuel_required(mass) do
    mass
    |> div(3)
    |> Kernel.-(2)
  end

  def module_masses do
    "../data/input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(fn line -> line |> String.trim_trailing() |> String.to_integer() end)
  end
end
