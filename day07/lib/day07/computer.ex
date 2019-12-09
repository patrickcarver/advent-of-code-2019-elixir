defmodule Day07.Computer do
  alias Day07.Data

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

  def process(3, %Data{program: program, pointer: pointer, input: inputs} = data) do
    if inputs == [] do
      %{data | state: :paused}
    else
      address = Map.get(program, pointer + 1)
      [input | remaining_inputs] = inputs
      updated_program = Map.put(program, address, input)
      %{data | program: updated_program, input: remaining_inputs, pointer: pointer + 2}
    end
  end

  def process({4, mode}, %Data{program: program, output: outputs, pointer: pointer} = data) do
    value = value(mode, program, pointer + 1)

    %{data | output: [value | outputs], pointer: pointer + 2}
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
    %{data | state: :halt}
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

  def run(%Data{program: program, pointer: pointer, state: :ready} = data) do
    opcode = Map.get(program, pointer)
    updated_data = handle_instruction(opcode, data)
    run(updated_data)
  end

  def run(%Data{state: state} = data) when state in [:halt, :paused] do
    data
  end



  def output(%Data{state: :paused, output: output}), do: Enum.reverse(output)
  def output(%Data{state: :halt, output: [head | _tail]}) do
    IO.puts "HALT"
    head
  end
  def output(_data), do: {:error, :invalid_state}
end
