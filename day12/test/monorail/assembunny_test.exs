defmodule Monorail.AssembunnyTest do
  use ExUnit.Case

  test "parsing source code" do
    source_code = """
    cpy 41 a
    inc a
    inc a
    dec a
    jnz a 2
    dec a
    """

    expected_program = [
      [:cpy, 41, :a],
      [:inc, :a],
      [:inc, :a],
      [:dec, :a],
      [:jnz, :a, 2],
      [:dec, :a]
    ]

    assert Monorail.Assembunny.parse(source_code) == expected_program
  end
end
