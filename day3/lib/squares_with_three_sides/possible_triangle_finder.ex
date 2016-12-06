defmodule SquaresWithThreeSides.PossibleTriangleFinder do
  @doc """
  iex> count("5 10 25")
  0
  iex> count("5 10 25\\n1 1 1")
  1
  """
  def count(input) do
    input
    |> parse_input
    |> Enum.filter(&possible_triangle?/1)
    |> Enum.count
  end

  defp possible_triangle?([a, b, c]) do
    a + b > c and
    a + c > b and
    b + a > c and
    b + c > a and
    c + a > b and
    c + b > a
  end

  defp parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn row ->
         String.split(row)
         |> Enum.map(&String.to_integer/1)
       end)
    |> Enum.reject(&Enum.empty?/1)
  end
end
