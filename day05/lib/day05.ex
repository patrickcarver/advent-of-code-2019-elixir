defmodule Day05 do
  defmodule Computer do
    def translate_opcode(opcode) do
      case opcode do
         1 -> {:add, 3}
         2 -> {:multiply, 3}
         3 -> {:input, 1}
         4 -> {:output, 1}
        99 -> {:halt, 0}
        _ -> {:error, :invalid_opcode}
      end
    end


    def modes(mode_codes, total_parameters) do
      mode_codes
      |> Enum.join()
      |> to_string()
      |> String.pad_trailing(total_parameters, "0")
      |> String.codepoints()
      |> Enum.take(2)
      |> Enum.map(fn
        "0" -> :position
        "1" -> :immediate
      end)
    end

    def translate(value) when value > 999 do
      [opcode, _zero | mode_codes] = value |> Integer.digits() |> Enum.reverse()
      {operation, total_parameters} = translate_opcode(opcode)
      modes = modes(mode_codes, total_parameters)
      {operation, modes, total_parameters}
    end

    def translate(value) when value in [3, 4] do
      {operation, total_parameters} = translate_opcode(value)
      {operation, [:position], total_parameters}
    end



    def translate(value) when value == 99 do
      {operation, total_parameters} = translate_opcode(value)
      {operation, nil, total_parameters}
    end

    def translate(_value) do
      {:error, :invalid_input, 0}
    end

    def value(:position, indexed_data, value_pointer) do
      address = Map.get(indexed_data, value_pointer)
      Map.get(indexed_data, address)
    end

    def value(:immediate, indexed_data, value_pointer) do
      Map.get(indexed_data, value_pointer)
    end

    def run(indexed_data, pointer, system_id) do
      {operation, modes, total_parameters} = indexed_data |> Map.get(pointer) |> translate()

      next_pointer = pointer + total_parameters + 1

      case operation do
        :add ->
          [noun_mode, verb_mode] = modes
          noun = value(noun_mode, indexed_data, pointer + 1)
          verb = value(verb_mode, indexed_data, pointer + 2)
          result = noun + verb
          address = Map.get(indexed_data, pointer + 3)
          next_indexed_data = Map.put(indexed_data, address, result)
          run(next_indexed_data, next_pointer, system_id)
        :multiply ->
          [noun_mode, verb_mode] = modes
          noun = value(noun_mode, indexed_data, pointer + 1)
          verb = value(verb_mode, indexed_data, pointer + 2)
          result = noun * verb
          address = Map.get(indexed_data, pointer + 3)
          next_indexed_data = Map.put(indexed_data, address, result)
          run(next_indexed_data, next_pointer, system_id)
        :input ->
          [mode] = modes
          input = value(mode, indexed_data, pointer + 1)
          IO.inspect input
          next_indexed_data = Map.put(indexed_data, input, system_id)
          run(next_indexed_data, next_pointer, system_id)
        :output ->
          output = value(:position, indexed_data, pointer + 1)
          IO.puts output
          run(indexed_data, next_pointer, system_id)
        :halt ->
          IO.puts "Program finished"
        :error ->
          IO.inspect {operation, modes, total_parameters}
      end

    end


  end

  def indexed_data(program) do
    program
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> {index, value} end)
    |> Enum.into(%{})
  end
  def part1 do
    indexed_data = load() |> indexed_data()
    pointer = 0
    system_id = 1
    Computer.run(indexed_data, pointer, system_id)
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
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
