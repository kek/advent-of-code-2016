defmodule BalanceBots.Control do
  def load(instructions) do
    instructions
    |> parse_instructions
    |> Enum.map(&execute_instruction/1)
  end

  def parse_instructions(instructions) do
    instructions
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  @doc """
  iex> parse_line("value 5 goes to bot 2")
  %BalanceBots.Instructions.Put{bot: 2, value: 5}
  iex> parse_line("bot 2 gives low to bot 1 and high to bot 0")
  %BalanceBots.Instructions.Compare{bot: 0, low: 1, high: 0}
  """
  def parse_line(line) do

  end

  def execute_instruction(instruction) do

  end
end
