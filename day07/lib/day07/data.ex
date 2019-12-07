defmodule Day07.Data do
  defstruct [
    program: [],
    pointer: 0,
    input: [],
    output: 0
  ]

  def new(program, input) do
    %__MODULE__{
      program: add_indexes(program),
      input: input
    }
  end

  def add_indexes(data) do
    data
    |> Stream.with_index()
    |> Stream.map(fn {value, index} -> {index, value} end)
    |> Enum.into(%{})
  end
end
