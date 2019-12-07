defmodule Day05 do
  defmodule Data do
    defstruct [
      program: [],
      pointer: 0,
      system_id: 1
    ]

    def new(program, system_id) do
      %__MODULE__{
        program: add_indexes(program),
        system_id: system_id
      }
    end

    def add_indexes(data) do
      data
      |> Stream.with_index()
      |> Stream.map(fn {value, index} -> {index, value} end)
      |> Enum.into(%{})
    end
  end

  defmodule Computer do
    alias Data

    # 0 -> position
    # 1 -> immediate

    def value(0, program, pointer) do
      address = Map.get(program, pointer)
      Map.get(program, address)
    end
    def value(1, program, pointer) do
      Map.get(program, pointer)
    end

    def process({1, noun_mode, verb_mode}, %Data{program: program, pointer: pointer} = data) do
      noun = value(noun_mode, program, pointer + 1)
      verb = value(verb_mode, program, pointer + 2)

      result = noun + verb

      result_address = Map.get(program, pointer + 3)

      updated_program = Map.put(program, result_address, result)
      %{data | program: updated_program, pointer: pointer + 4}
    end

    def process({2, noun_mode, verb_mode}, %Data{program: program, pointer: pointer} = data) do
      noun = value(noun_mode, program, pointer + 1)
      verb = value(verb_mode, program, pointer + 2)

      result = noun * verb

      result_address = Map.get(program, pointer + 3)
      updated_program = Map.put(program, result_address, result)
      %{data | program: updated_program, pointer: pointer + 4}
    end

    def process(3, %Data{program: program, pointer: pointer, system_id: system_id} = data) do
      address = Map.get(program, pointer + 1)
      updated_program = Map.put(program, address, system_id)
      %{data | program: updated_program, pointer: pointer + 2}
    end

    def process({4, mode}, %Data{program: program, pointer: pointer} = data) do
      value = value(mode, program, pointer + 1)
      IO.puts value
      %{data | pointer: pointer + 2}
    end

    def process({5, noun_mode, verb_mode}, %Data{program: program, pointer: pointer} = data) do
      noun = value(noun_mode, program, pointer + 1)
      verb = value(verb_mode, program, pointer + 2)

      result = if noun != 0, do: verb, else: pointer + 3

      %{data | pointer: result}
    end

    def process({6, noun_mode, verb_mode}, %Data{program: program, pointer: pointer} = data) do
      noun = value(noun_mode, program, pointer + 1)
      verb = value(verb_mode, program, pointer + 2)

      result = if noun == 0, do: verb, else: pointer + 3

      %{data | pointer: result}
    end

    def process({7, noun_mode, verb_mode}, %Data{program: program, pointer: pointer} = data) do
      noun = value(noun_mode, program, pointer + 1)
      verb = value(verb_mode, program, pointer + 2)

      result = if noun < verb, do: 1, else: 0

      result_address = Map.get(program, pointer + 3)
      updated_program = Map.put(program, result_address, result)
      %{data | program: updated_program, pointer: pointer + 4}
    end

    def process({8, noun_mode, verb_mode}, %Data{program: program, pointer: pointer} = data) do
      noun = value(noun_mode, program, pointer + 1)
      verb = value(verb_mode, program, pointer + 2)

      result = if noun == verb, do: 1, else: 0

      result_address = Map.get(program, pointer + 3)
      updated_program = Map.put(program, result_address, result)
      %{data | program: updated_program, pointer: pointer + 4}
    end

    def process(99, data) do
      {:halt, data}
    end

    def handle_instruction(value, data) do
      value
      |> normalize()
      |> process(data)
    end

    def normalize(opcode) when opcode in [1,2,5,6,7,8] do
      {opcode, 0, 0}
    end

    def normalize(4) do
      {4, 0}
    end

    def normalize(opcode) when opcode in [3, 99] do
      opcode
    end

    def normalize(value) when value > 999 do
      [verb_mode, noun_mode, 0, opcode] = Integer.digits(value)
      {opcode, noun_mode, verb_mode}
    end

    def normalize(value) when value > 99 do
      [mode, 0, opcode] = Integer.digits(value)
      case opcode do
        1 -> {1, mode, 0}
        2 -> {2, mode, 0}
        4 -> {4, mode}
        5 -> {5, mode, 0}
        6 -> {6, mode, 0}
        7 -> {7, mode, 0}
        8 -> {8, mode, 0}
      end
    end

    def run(%Data{program: program, pointer: pointer} = data) do
      opcode = Map.get(program, pointer)
      updated_data = handle_instruction(opcode, data)
      run(updated_data)
    end

    def run({:halt, data}) do
      data
    end
  end

  def part1 do
    load()
    |> Data.new(1)
    |> Computer.run()
  end

  def part2 do
    load()
    |> Data.new(5)
    |> Computer.run()
  end

  def load() do
    "../data/input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> hd()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
