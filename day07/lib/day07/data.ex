defmodule Day07.Data do
  defstruct [
    program: [],
    pointer: 0,
    input: [],
    output: [],
    state: :ready
  ]

  def new(program, input) do
    IO.inspect input
    %__MODULE__{
      program: add_indexes(program),
      input: input
    }
  end

  def new(program) do
    %__MODULE__{
      program: add_indexes(program)
    }
  end

  def input(data, input) do
    %{data | input: input, state: :ready}
  end

  def add_indexes(data) do
    data
    |> Stream.with_index()
    |> Stream.map(fn {value, index} -> {index, value} end)
    |> Enum.into(%{})
  end
end
