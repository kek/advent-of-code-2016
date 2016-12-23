defmodule Monorail.Instructions do
  @doc """
  iex> inc(%{registers: {0, 0, 0, 0}, pc: 0, program: [[:foo, 1]]}, :a)
  %{registers: {1, 0, 0, 0}, pc: 1, program: [[:foo, 1]]}
  iex> inc(%{registers: {0, 0, 0, 0}, pc: 0, program: [[:foo, 1]]}, :b)
  %{registers: {0, 1, 0, 0}, pc: 1, program: [[:foo, 1]]}
  iex> inc(%{registers: {0, 0, 0, 0}, pc: 0, program: [[:foo, 1]]}, :c)
  %{registers: {0, 0, 1, 0}, pc: 1, program: [[:foo, 1]]}
  iex> inc(%{registers: {0, 0, 0, 0}, pc: 0, program: [[:foo, 1]]}, :d)
  %{registers: {0, 0, 0, 1}, pc: 1, program: [[:foo, 1]]}
  """
  def inc(state = %{registers: {a, b, c, d}, pc: pc}, :a) do
    %{state | registers: {a + 1, b, c, d}, pc: pc + 1}
  end
  def inc(state = %{registers: {a, b, c, d}, pc: pc}, :b) do
    %{state | registers: {a, b + 1, c, d}, pc: pc + 1}
  end
  def inc(state = %{registers: {a, b, c, d}, pc: pc}, :c) do
    %{state | registers: {a, b, c + 1, d}, pc: pc + 1}
  end
  def inc(state = %{registers: {a, b, c, d}, pc: pc}, :d) do
    %{state | registers: {a, b, c, d + 1}, pc: pc + 1}
  end

  @doc """
  iex> cpy(%{registers: {0, 0, 0, 0}, pc: 0, program: []}, 42, :a)
  %{registers: {42, 0, 0, 0}, pc: 1, program: []}
  """
  def cpy(state = %{registers: {a, b, c, d}}, value, :a) do
    %{state | pc: state.pc + 1, registers: {value, b, c, d}}
  end

  def dec(state, register) do
    state
  end

  def jnz(state, register, address) do
    state
  end
end
