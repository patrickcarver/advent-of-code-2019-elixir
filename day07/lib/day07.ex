defmodule Day07 do
  alias Day07.{Computer, Data}

  def part1 do
    program = "../data/input.txt" |> load()

    [0,1,2,3,4]
    |> permutations()
    |> Enum.map(fn phases -> thrust(program, phases, 0) end)
    |> Enum.max()
  end

  def part2 do
    permutations = permutations([5,6,7,8,9])

    #program = "../data/input.txt" |> load()
    program = "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10" |> String.split(",") |> Enum.map(&String.to_integer/1)

  end


  def thrust(program, phases, init_input) do
    Enum.reduce(phases, init_input, fn phase, input ->
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
