defmodule Day05 do
  defmodule Computer do
    def run(indexed_data, pointer, system_id) do
      opcode = indexed_data |> Map.get(pointer)
      handle_opcode(opcode, indexed_data, pointer, system_id)
    end

    def value(:position, indexed_data, value_pointer) do
      address = Map.get(indexed_data, value_pointer)
      Map.get(indexed_data, address)
    end

    def value(:immediate, indexed_data, value_pointer) do
      Map.get(indexed_data, value_pointer)
    end

    def translate_to_mode(num) do
      case num do
        0 -> :position
        1 -> :immediate
        _ -> {:error, "not a valid mode number"}
      end
    end

    def execute(indexed_data, pointer, operation, [noun_mode, verb_mode]) do
      noun = value(noun_mode, indexed_data, pointer + 1)
      verb = value(verb_mode, indexed_data, pointer + 2)

      result = operation.(noun, verb)
      result_address = Map.get(indexed_data, pointer + 3)
      Map.put(indexed_data, result_address, result)
    end

    def operation(num) do
      case num do
        1 -> &Kernel.+/2
        2 -> &Kernel.*/2
        _ -> {:error, num}
      end
    end

    # add
    def handle_opcode(1, indexed_data, pointer, system_id) do
      next_indexed_data = execute(indexed_data, pointer, &Kernel.+/2, [:position, :position])

      run(next_indexed_data, pointer + 4, system_id)
    end

    # multiply
    def handle_opcode(2, indexed_data, pointer, system_id) do
      next_indexed_data = execute(indexed_data, pointer, &Kernel.*/2, [:position, :position])

      run(next_indexed_data, pointer + 4, system_id)
    end

    # input
    def handle_opcode(3, indexed_data, pointer, system_id) do
      value = value(:position, indexed_data, pointer + 1)
      next_indexed_data = Map.put(indexed_data, value, system_id)

      run(next_indexed_data, pointer + 2, system_id)
    end

    # output
    def handle_opcode(4, indexed_data, pointer, system_id) do
      value = value(:position, indexed_data, pointer + 1)
      IO.inspect "value is #{value}"

      run(indexed_data, pointer + 2, system_id)
    end

    def handle_opcode(99, _indexed_data, _pointer, _system_id) do
      IO.puts "Program ended"
    end

    def handle_opcode(opcode_and_parameter_modes, indexed_data, pointer, system_id) when opcode_and_parameter_modes > 999 do
      IO.inspect opcode_and_parameter_modes
      IO.inspect pointer
      [verb_mode_num, noun_mode_num | opcode_list ] = opcode_and_parameter_modes |> Integer.digits()
      verb_mode = translate_to_mode(verb_mode_num)
      noun_mode = translate_to_mode(noun_mode_num)

      opcode = opcode_list |> Enum.join() |> String.to_integer()
      operation = operation(opcode)

      next_indexed_data = execute(indexed_data, pointer, operation, [noun_mode, verb_mode])

      run(next_indexed_data, pointer + 4, system_id)
    end

    def handle_opcode(opcode, _indexed_data, _pointer, _system_id) do
      {:error, "#{opcode} is invalid"}
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
