defmodule Day05.Memory do
  def initialize(data) do
    data
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.map(fn {value, key} -> {key, String.to_integer(value)} end)
    |> Enum.into(%{})
  end

  def update(memory, address, function) do
    result = results(memory, address, function)
    output_address = output_address(memory, address)

    Map.put(memory, output_address, result)
  end

  def change_input(memory, noun, verb) do
    memory
    |> Map.put(1, noun)
    |> Map.put(2, verb)
  end

  defp results(memory, address, function) do
    input_values = input_values(memory, address)
    apply(function, input_values)
  end

  defp output_address(memory, address) do
    Map.get(memory, address + 3)
  end

  defp noun(memory, address) do
    input_value(memory, address, 1)
  end

  defp verb(memory, address) do
    input_value(memory, address, 2)
  end

  defp input_value(memory, address, offset) do
    value_address = Map.get(memory, address + offset)
    Map.get(memory, value_address)
  end

  defp input_values(memory, address) do
    noun = noun(memory, address)
    verb = verb(memory, address)
    [noun, verb]
  end
end
