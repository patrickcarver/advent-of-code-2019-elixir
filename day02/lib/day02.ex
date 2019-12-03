defmodule Day02 do
  alias Day02.Program

  def part1 do
    load()
    |> Program.initialize_memory()
    |> restore_1202_program_alarm()
  end

  def part2 do
    load()
    |> Program.initialize_memory()
    |> calculation_with_inputs_that_result_in_19690720(inputs())
  end

  defp restore_1202_program_alarm(memory) do
    Program.value_at_first_position(memory, 12, 2)
  end

  defp calculation_with_inputs_that_result_in_19690720(memory, [{noun, verb} | rest]) do
    result = Program.value_at_first_position(memory, noun, verb)

    case result do
      19690720 ->
        100 * noun + verb
      _ ->
        calculation_with_inputs_that_result_in_19690720(memory, rest)
    end
  end

  defp inputs() do
    for noun <- 0..99, verb <- 0..99, do: {noun, verb}
  end

  defp load do
    "../data/input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
    |> hd()
  end
end
