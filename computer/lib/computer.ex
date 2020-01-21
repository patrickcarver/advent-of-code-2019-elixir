defmodule Computer do
  defstruct [
    program: [],
    instruction_pointer: 0,
    state: active
  ]

  def run(computer) do
    computer
    |> instruction()
  end

  def new(intcode_string) do
    program = program(intcode_string)
    %__MODULE__{
      program: program
    }
  end

  defp instruction(instruction) do
    {function, total_parameters} = function(instruction)
    modes = modes(total_parameters)
  end

  defp modes(total_parameters) do
    List.duplicate(:position, total_parameters)
  end

  defp value(computer, offset, mode) do
    address = computer.instruction_pointer + offset
    value_address = Map.get(computer.program, address)

    case mode do
      :position ->
        Map.get(computer.program, value_address)
      :immediate ->
        value_address
    end
  end

  defp store_result(computer, result, offset, mode) do
    address = computer.instruction_pointer + offset
    value_address = Map.get(computer.program, address)

    case mode do
      :position ->
        storage_address = Map.get(computer.program, value_address)
        Map.put(computer.program, storage_address, result)
      :immediate ->
        Map.put(computer.program, value_address, result)
    end
  end

  defp add(computer, [p1_mode, p2_mode, p3_mode]) do
    p1 = value(computer, 1, p1_mode)
    p2 = value(computer, 2, p2_mode)

    result = p1 + p2

    program = store_result(computer, result, 3, p3_mode)

    computer
    |> Map.put(:program, program)
    |> Map.update!(:instruction_pointer, & &1 + 4)
  end

  defp multiply(computer, modes) do

  end

  defp halt(computer, _modes) do
    %__MODULE__{state: :halted}
  end

  defp error(computer, _modes) do
    %__MODULE__{state: :error}
  end

  defp function(1), do:  {&add/2, 3}
  defp function(2), do:  {&multiply/2, 3}
  defp function(99), do: {&halt/2, 0}
  defp function(_), do:  {&error/2, 0}

  defp program(intcode_string) do
    intcode_string
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> {index, String.to_integer(value)})
    |> Enum.into(%{})
  end
end
