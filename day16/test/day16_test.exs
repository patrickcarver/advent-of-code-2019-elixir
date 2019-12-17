defmodule Day16Test do
  use ExUnit.Case
  doctest Day16

  test "repeated pattern" do
    pattern = [0, 1, 0, -1]
    len = 8
    assert Day16.repeated_pattern(pattern, len, 1) == [1,0,-1,0,1,0,-1,0]
    assert Day16.repeated_pattern(pattern, len, 2) == [0,1,1,0,0,-1,-1,0]
    assert Day16.repeated_pattern(pattern, len, 3) == [0,0,1,1,1,0,0,0]
    assert Day16.repeated_pattern(pattern, len, 4) == [0,0,0,1,1,1,1,0]
    assert Day16.repeated_pattern(pattern, len, 5) == [0,0,0,0,1,1,1,1]
    assert Day16.repeated_pattern(pattern, len, 6) == [0,0,0,0,0,1,1,1]
    assert Day16.repeated_pattern(pattern, len, 7) == [0,0,0,0,0,0,1,1]
    assert Day16.repeated_pattern(pattern, len, 8) == [0,0,0,0,0,0,0,1]
  end

  test "patterns" do
    pattern = [0, 1, 0, -1]
    len = 8
    assert Day16.patterns(pattern, len) ==
      [
        [1,0,-1,0,1,0,-1,0],
        [0,1,1,0,0,-1,-1,0],
        [0,0,1,1,1,0,0,0],
        [0,0,0,1,1,1,1,0],
        [0,0,0,0,1,1,1,1],
        [0,0,0,0,0,1,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,0,1]
      ]
  end

  test "signal to digits" do
    assert Day16.to_digits("1234") == [1,2,3,4]
    assert Day16.to_digits("0123") == [0,1,2,3]
  end

  test "signal of 12345678 with 1, 2, 3, 4 phases" do
    assert Day16.fft("12345678", 1) == "48226158"
    assert Day16.fft("12345678", 2) == "34040438"
    assert Day16.fft("12345678", 3) == "03415518"
    assert Day16.fft("12345678", 4) == "01029498"
  end

  test "signal of 80871224585914546619083218645595 with 100 phases" do
    assert Day16.fft("80871224585914546619083218645595", 100) == "24176176"
  end

  test "signal of 19617804207202209144916044189917 with 100 phases" do
    assert Day16.fft("19617804207202209144916044189917", 100) == "73745418"
  end

  test "signal of 69317163492948606335995924319873 with 100 phases" do
    assert Day16.fft("69317163492948606335995924319873", 100) == "52432133"
  end
end
