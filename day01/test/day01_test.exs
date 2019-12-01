defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  test "fuel required" do
    assert Day01.fuel_required(12) == 2
    assert Day01.fuel_required(14) == 2
    assert Day01.fuel_required(1969) == 654
    assert Day01.fuel_required(100756) == 33583
  end

  test "Day 01 Part 1 result" do
    assert Day01.part1() == 3392373
  end

  test "recursive fuel calculation" do
    assert Day01.total_fuel_required(12, 0) == 2
    assert Day01.total_fuel_required(1969, 0) == 966
    assert Day01.total_fuel_required(100756, 0) == 50346
  end

  test "Day 01 Part 2 result" do
    assert Day01.part2() == 5085699
  end

  test "Day 01 Part 2 with stream iteration result" do
    assert Day01.part2_with_stream_iterate() == 5085699
  end
end
