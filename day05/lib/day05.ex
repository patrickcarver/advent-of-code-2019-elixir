defmodule Day05 do
  defmodule Data do
    defstruct [
      program: [],
      pointer: 0,
      system_id: 1
    ]

    def new(program) do
      %__MODULE__{
        program: add_indexes(program)
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

    def handle_opcode(1,  %Data{program: program, pointer: pointer} = data, [noun_mode, verb_mode]) do
      noun = value(noun_mode, program, pointer + 1)
      verb = value(verb_mode, program, pointer + 2)
      result = noun + verb
      result_address = Map.get(program, pointer + 3)
      updated_program = Map.put(program, result_address, result)
      %{data | program: updated_program, pointer: pointer + 4}
    end

    def handle_opcode(2,  %Data{program: program, pointer: pointer} = data, [noun_mode, verb_mode]) do
      noun = value(noun_mode, program, pointer + 1)
      verb = value(verb_mode, program, pointer + 2)
      result = noun * verb
      result_address = Map.get(program, pointer + 3)
      updated_program = Map.put(program, result_address, result)
      %{data | program: updated_program, pointer: pointer + 4}
    end

    # 4-digit value
    def handle_opcode(value, data) when value > 999 do
      [verb_mode, noun_mode, 0, opcode] = Integer.digits(value)
      handle_opcode(opcode, data, [noun_mode, verb_mode])
    end

    # add - all parameters are position
    def handle_opcode(1, %Data{program: program, pointer: pointer} = data) do
      noun = value(0, program, pointer + 1)
      verb = value(0, program, pointer + 2)
      result = noun + verb
      result_address = Map.get(program, pointer + 3)
      updated_program = Map.put(program, result_address, result)
      %{data | program: updated_program, pointer: pointer + 4}
    end

    # multiply - add parameters are position
    def handle_opcode(2, %Data{program: program, pointer: pointer} = data) do
      noun = value(0, program, pointer + 1)
      verb = value(0, program, pointer + 2)
      result = noun * verb
      result_address = Map.get(program, pointer + 3)
      updated_program = Map.put(program, result_address, result)
      %{data | program: updated_program, pointer: pointer + 4}
    end

    # input
    def handle_opcode(3, %Data{program: program, pointer: pointer, system_id: system_id} = data) do
      address = Map.get(program, pointer + 1)
      updated_program = Map.put(program, address, system_id)
      %{data | program: updated_program, pointer: pointer + 2}
    end

    # output
    def handle_opcode(4, %Data{program: program, pointer: pointer} = data) do
      address = Map.get(program, pointer + 1)
      value = Map.get(program, address)
      IO.puts "The value at address #{address} is #{value}"
      %{data | pointer: pointer + 2}
    end

    # halt
    def handle_opcode(99, _data) do
      IO.puts "Program finished"
    end

    def run(%Data{program: program, pointer: pointer} = data) do
      opcode = Map.get(program, pointer)
      updated_data = handle_opcode(opcode, data)
      run(updated_data)
    end

    def run(:ok) do
      :ok
    end
  end

  def part1 do
    load()
    |> Data.new()
    |> Computer.run()
  end

  def part2 do
    :noop
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
