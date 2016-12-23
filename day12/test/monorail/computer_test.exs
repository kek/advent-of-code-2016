defmodule Monorail.ComputerTest do
  use ExUnit.Case
  doctest Monorail.Computer, import: true
  alias Monorail.Computer

  setup do
    Computer.start_link
    :ok
  end

  test "loading a program" do
    Computer.load("")
    Computer.run
    assert Computer.registers == {0, 0, 0, 0}
  end

  test "incrementing" do
    Computer.load("inc a")
    Computer.run
    assert Computer.registers == {1, 0, 0, 0}
  end
end
