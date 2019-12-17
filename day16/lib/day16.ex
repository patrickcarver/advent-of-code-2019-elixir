defmodule Day16 do

  def part1() do
    "../data/input.txt"
    |> load()
    |> fft(100)
  end

  def fft(signal, phase, pattern \\ [0, 1, 0, -1])

  def fft(signal, 0, _pattern) do
    String.slice(signal, 0, 8)
  end

  def fft(signal, phase, pattern) do
    len = String.length(signal)
    digits = to_digits(signal)

    list_of_digits = List.duplicate(digits, len)
    patterns = patterns(pattern, len)
    next_signal = next_signal(list_of_digits, patterns, [])

    fft(next_signal, phase - 1, pattern)
  end

  def next_signal([], [], results) do
    results
    |> Enum.reverse()
    |> Enum.join()
  end

  def next_signal([head_digits | rest_digits], [head_pattern | rest_patterns], results) do
    result = output_element(head_digits, head_pattern)
    next_signal(rest_digits, rest_patterns, [result | results])
  end

  def output_element(digits, pattern) do
    Enum.zip(digits, pattern)
    |> Enum.reduce(0, fn {first, second}, acc ->
      acc + (first * second)
    end)
    |> to_string()
    |> String.last()
  end

  def patterns(pattern, len) do
    Enum.map(1..len, & repeated_pattern(pattern, len, &1))
  end

  def repeated_pattern(pattern, len, times) do
    pattern
    |> Enum.chunk_by(& &1)
    |> Enum.flat_map(& List.duplicate(&1, times))
    |> List.flatten()
    |> Stream.cycle()
    |> Stream.take(len + 1)
    |> Enum.drop(1)
  end

  def to_digits(signal) do
    signal
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
  end

  def load(file_name) do
    file_name
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.to_list()
    |> hd()
  end
end
