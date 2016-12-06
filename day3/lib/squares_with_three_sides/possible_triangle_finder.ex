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
    |> filter_out_impossible
    |> Enum.count
  end

  def rotated_count(input) do
    input
    |> parse_input
    |> rotate
    |> filter_out_impossible
    |> Enum.count
  end

  @doc """
  iex> rotate([[:a, :b, :c], [:a, :b, :c], [:a, :b, :c]])
  [[:a, :a, :a], [:b, :b, :b], [:c, :c, :c]]
  """
  def rotate(rows) do
    numbers =
      Enum.map(rows, &Enum.at(&1, 0)) ++
      Enum.map(rows, &Enum.at(&1, 1)) ++
      Enum.map(rows, &Enum.at(&1, 2))
    Enum.chunk(numbers, 3)
  end

  defp filter_out_impossible(triangles) do
    Enum.filter(triangles, &possible_triangle?/1)
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
