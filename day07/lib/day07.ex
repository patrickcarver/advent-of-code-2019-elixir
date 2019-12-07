defmodule Day07 do
  alias Day07.{Computer, Data}

  def part1 do
    program = "../data/input.txt" |> load()

    [0,1,2,3,4]
    |> permutations()
    |> Enum.map(fn phases -> thrust(program, phases) end)
    |> Enum.max()
  end

  def thrust(program, phases) do
    Enum.reduce(phases, 0, fn phase, input ->
      program
      |> Data.new([phase, input])
      |> Computer.run()
      |> Computer.output()
    end)
  end


  def permutations([]), do: [[]]
  def permutations(list) do
    for x <- list, y <- permutations(list -- [x]), do: [x|y]
  end

  def part2 do
    :noop
  end

  def load(file_name) do
    file_name
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> hd()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
