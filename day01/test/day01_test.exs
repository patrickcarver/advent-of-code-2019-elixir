defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  test "test fuel required" do
    # assert Day01.hello() == :world
    assert Day01.fuel_required(12) == 2
    assert Day01.fuel_required(14) == 2
    assert Day01.fuel_required(1969) == 654
    assert Day01.fuel_required(100756) == 33583
  end
end
