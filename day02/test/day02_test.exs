defmodule Day02Test do
  use ExUnit.Case
  doctest Day02

  test "1,0,0,0,99" do
    int_code = "1,0,0,0,99" |> Day02.convert_to_map()
    position = 0

    actual = Day02.loop(int_code, position)
    expected = "2,0,0,0,99" |> Day02.convert_to_map()
    assert actual == expected
  end

  test "2,3,0,3,99" do
    int_code = "2,3,0,3,99" |> Day02.convert_to_map()
    position = 0

    actual = Day02.loop(int_code, position)
    expected = "2,3,0,6,99" |> Day02.convert_to_map()
    assert actual == expected
  end

  test "2,4,4,5,99,0"  do
    int_code = "2,4,4,5,99,0" |> Day02.convert_to_map()
    position = 0

    actual = Day02.loop(int_code, position)
    expected = "2,4,4,5,99,9801" |> Day02.convert_to_map()
    assert actual == expected
  end

  test "1,1,1,4,99,5,6,0,99"  do
    int_code = "1,1,1,4,99,5,6,0,99" |> Day02.convert_to_map()
    position = 0

    actual = Day02.loop(int_code, position)
    expected = "30,1,1,4,2,5,6,0,99" |> Day02.convert_to_map()
    assert actual == expected
  end
end
