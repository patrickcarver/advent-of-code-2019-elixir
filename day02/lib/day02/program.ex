defmodule Day02.Program do
  alias Day02.Memory

  def run(memory, address \\ 0)

  def run(memory, address) do
    function = memory |> Map.get(address) |> function()

    case function do
      :halt ->
        memory
      _ ->
        memory
        |> Memory.update(address, function)
        |> run(address + 4)
    end
  end

  defp function(opcode) do
    %{
      1 => &Kernel.+/2,
      2 => &Kernel.*/2,
      99 => :halt
    } |> Map.get(opcode)
  end

  def value_at_first_position(memory, noun, verb) do
    memory
    |> Memory.change_input(noun, verb)
    |> run()
    |> Map.get(0)
  end

  def initialize_memory(data) do
    Memory.initialize(data)
  end
end
