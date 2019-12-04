defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  test "part1" do
    assert Day03.part1() == 1017
  end

  test "part2" do
    assert Day03.part2() == 11432
  end
end
