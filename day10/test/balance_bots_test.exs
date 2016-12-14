defmodule BalanceBotsTest do
  use ExUnit.Case
  doctest BalanceBots

  test "simple case" do
    instructions = """
    value 5 goes to bot 2
    bot 2 gives low to bot 1 and high to bot 0
    value 3 goes to bot 1
    bot 1 gives low to output 1 and high to bot 0
    bot 0 gives low to output 2 and high to output 0
    value 2 goes to bot 2
    """

    BalanceBots.Control.load(instructions)
    Process.sleep 100
    assert BalanceBots.Output.get(0) == 5
    assert BalanceBots.Output.get(1) == 2
    assert BalanceBots.Output.get(2) == 3
    %{values: values} = BalanceBots.Bot.get_state(2)
    assert Enum.member?(2, values)
    assert Enum.member?(5, values)
  end
end
