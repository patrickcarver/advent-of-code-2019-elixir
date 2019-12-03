defmodule Day02Test do
  use ExUnit.Case
  doctest Day02

  test "1,0,0,0,99" do
    actual = "1,0,0,0,99" |> Day02.Memory.initialize() |> Day02.Program.run()
    expected = "2,0,0,0,99" |> Day02.Memory.initialize()
    assert actual == expected
  end

  test "2,3,0,3,99" do
    actual = "2,3,0,3,99" |> Day02.Memory.initialize() |> Day02.Program.run()
    expected = "2,3,0,6,99" |> Day02.Memory.initialize()
    assert actual == expected
  end

  test "2,4,4,5,99,0" do
    actual = "2,4,4,5,99,0" |> Day02.Memory.initialize() |> Day02.Program.run()
    expected = "2,4,4,5,99,9801" |> Day02.Memory.initialize()
    assert actual == expected
  end

  test "1,1,1,4,99,5,6,0,99" do
    actual = "1,1,1,4,99,5,6,0,99" |> Day02.Memory.initialize() |> Day02.Program.run()
    expected = "30,1,1,4,2,5,6,0,99" |> Day02.Memory.initialize()
    assert actual == expected
  end

  test "part1" do
    assert Day02.part1 == 3654868
  end

  test "part2" do
    assert Day02.part2 == 7014
  end
end
