defmodule Monorail.Instructions do
  @doc """
  iex> inc({0, 0, 0, 0}, :a)
  {1, 0, 0, 0}
  """
  def inc({0, 0, 0, 0}, :a) do
    {1, 0, 0, 0}
  end
end
