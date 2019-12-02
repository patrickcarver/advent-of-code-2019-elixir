defmodule Day02 do
  def opcode_values(opcode) do
    values = %{
      1 => &Kernel.+/2,
      2 => &Kernel.*/2,
      99 => :halt
    }

    Map.get(values, opcode)
  end

  def loop(int_code, current_position \\ 0)
  def loop(int_code, current_position) do
    current_opcode = Map.get(int_code, current_position)
    current_opcode_value = opcode_values(current_opcode)

    case current_opcode_value do
      :halt ->
        int_code
      _ ->
        input1_position = Map.get(int_code, current_position + 1)
        input2_position = Map.get(int_code, current_position + 2)
        output_position = Map.get(int_code, current_position + 3)

        input1 = Map.get(int_code, input1_position)
        input2 = Map.get(int_code, input2_position)

        result = apply(current_opcode_value, [input1, input2])

        updated_int_code = Map.put(int_code, output_position, result)
        updated_position = current_position + 4

        loop(updated_int_code, updated_position)
    end
  end

  def change_input(map, noun, verb) do
    map
    |> Map.put(1, noun)
    |> Map.put(2, verb)
  end

  @spec part1 :: any
  def part1 do
    load()
    |> convert_to_map()
    |> change_input(12, 2)
    |> loop()
    |> Map.get(0)
  end

  def find_pair_of_inputs_resulting_in_target(int_code, target, [{noun, verb} | rest]) do
    result =
      int_code
      |> change_input(noun, verb)
      |> loop()
      |> Map.get(0)

    case result do
      ^target ->
        100 * noun + verb
      _ ->
        find_pair_of_inputs_resulting_in_target(int_code, target, rest)
    end
  end

  def inputs() do
    for noun <- 0..99, verb <- 0..99, do: {noun, verb}
  end

  def part2 do
    int_code = load() |> convert_to_map()
    target = 19690720
    inputs = inputs()

    find_pair_of_inputs_resulting_in_target(int_code, target, inputs)
  end

  def load do
    "../data/input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> hd()
  end

  def convert_to_map(data) do
    data
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn {value, key} -> {key, value} end)
    |> Enum.into(%{})
  end
end
