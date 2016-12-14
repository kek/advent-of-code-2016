defmodule BalanceBots.Instructions do
  defmodule Put do
    defstruct [:bot, :value]
  end
  defmodule Compare do
    defstruct [:bot, :low, :high]
  end
  defstruct values: [], low: nil, high: nil
end
