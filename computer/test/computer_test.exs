defmodule ComputerTest do
  use ExUnit.Case
  doctest Computer

  test "" do
    intcode = "1,9,10,3,2,3,11,0,99,30,40,50"
    computer = Computer.new(intcode)
    assert computer.state == :active

    halted_computer = Computer.run(computer)
    assert halted_computer.state == :halted
  end
end
