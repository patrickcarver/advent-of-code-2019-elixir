defmodule Day01 do
  def part1 do
    run(&fuel_required/1)
  end

  def part2 do
    run(&total_fuel_required/1)
  end

  def part2_with_stream_iterate do
    run(&iterate/1)
  end

  def run(function_name) do
    module_masses()
    |> Stream.map(function_name)
    |> Enum.sum
  end

  def total_fuel_required(mass, acc \\ 0) do
    fuel = fuel_required(mass)

    if fuel > 0 do
      total_fuel_required(fuel, acc + fuel)
    else
      acc
    end
  end

  def iterate(mass) do
    mass
    |> Stream.iterate(&fuel_required/1)
    |> Enum.take_while(& &1 > 0)
    |> tl() # remove the module mass which would be the first in the list
    |> Enum.sum()
  end

  def fuel_required(mass) do
    div(mass, 3) - 2
  end

  def module_masses do
    "../data/input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.to_integer/1)
  end
end
