defmodule MonorailTest do
  use ExUnit.Case

  test "empty program" do
    Monorail.Computer.load("")
    Monorail.Computer.run
    assert {0, 0, 0, 0} == Monorail.Computer.registers
  end

  test "simple program" do
    source_code = """
    cpy 41 a
    inc a
    inc a
    dec a
    jnz a 2
    dec a
    """
    Monorail.Computer.load(source_code)
    Monorail.Computer.run

    assert {42, _, _, _} = Monorail.Computer.registers
  end
end
