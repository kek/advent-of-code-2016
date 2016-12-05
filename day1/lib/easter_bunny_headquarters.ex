defmodule EasterBunnyHeadquarters do
  @moduledoc """
  --- Day 1: No Time for a Taxicab ---

  Santa's sleigh uses a very high-precision clock to guide its movements, and the clock's oscillator
  is regulated by stars. Unfortunately, the stars have been stolen... by the Easter Bunny. To save
  Christmas, Santa needs you to retrieve all fifty stars by December 25th.

  Collect stars by solving puzzles. Two puzzles will be made available on each day in the advent
  calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star.
  Good luck!

  You're airdropped near Easter Bunny Headquarters in a city somewhere. "Near", unfortunately, is as
  close as you can get - the instructions on the Easter Bunny Recruiting Document the Elves
  intercepted start here, and nobody had time to work them out further.

  The Document indicates that you should start at the given coordinates (where you just landed) and
  face North. Then, follow the provided sequence: either turn left (L) or right (R) 90 degrees, then
  walk forward the given number of blocks, ending at a new intersection.

  There's no time to follow such ridiculous instructions on foot, though, so you take a moment and
  work out the destination. Given that you can only walk on the street grid of the city, how far is
  the shortest path to the destination?

  For example:

  Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away.
  R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2 blocks away.
  R5, L5, R5, R3 leaves you 12 blocks away.
  How many blocks away is Easter Bunny HQ?
  """

  @doc """
  iex> EasterBunnyHeadquarters.distance("")
  0
  iex> EasterBunnyHeadquarters.distance("R1")
  1
  iex> EasterBunnyHeadquarters.distance("R1, L1")
  2
  iex> EasterBunnyHeadquarters.distance("R2, L3")
  5
  iex> EasterBunnyHeadquarters.distance("R2, R2, R2")
  2
  iex> EasterBunnyHeadquarters.distance("R5, L5, R5, R3")
  12
  iex> EasterBunnyHeadquarters.distance("L1, L1, L1, L1")
  0
  iex> EasterBunnyHeadquarters.distance("R1, R1, R1, R1")
  0
  """
  def distance(path) when is_binary(path) do
    path
    |> parse_path
    |> distance
  end
  def distance(path) do
    origin = {:north, 0, 0}
    {_, x, y} = destination(origin, path)
    abs(x + y)
  end

  defp destination(position = {_, _, _}, []),         do: position
  defp destination({:north, x, y}, [{:r, n} | rest]), do: destination({:east, x, y + n}, rest)
  defp destination({:north, x, y}, [{:l, n} | rest]), do: destination({:west, x, y - n}, rest)
  defp destination({:east,  x, y}, [{:r, n} | rest]), do: destination({:south, x, y - n}, rest)
  defp destination({:east,  x, y}, [{:l, n} | rest]), do: destination({:north, x, y + n}, rest)
  defp destination({:west,  x, y}, [{:r, n} | rest]), do: destination({:north, x, y + n}, rest)
  defp destination({:west,  x, y}, [{:l, n} | rest]), do: destination({:south, x, y - n}, rest)
  defp destination({:south, x, y}, [{:r, n} | rest]), do: destination({:west, x - n, y}, rest)
  defp destination({:south, x, y}, [{:l, n} | rest]), do: destination({:east, x, y + n}, rest)

  # defp distance([], position), do: 0
  # defp distance([{:r, steps}], {:north, x, y}), do: steps
  # defp distance([{:r, steps}], {:east, x, y}), do: steps
  # defp distance([{:r, steps}], {:south, x, y}), do: steps
  # defp distance([{:r, steps}], {:west, x, y}), do: steps
  # defp distance([{:l, steps}], {:north, x, y}), do: steps
  # defp distance([{:l, steps}], {:east, x, y}), do: steps
  # defp distance([{:l, steps}], {:south, x, y}), do: steps
  # defp distance([{:l, steps}], {:west, x, y}), do: steps
  # defp distance([head | tail], position = {:north, x, y}) do
  #   distance([head], position) + distance(tail, position)
  # end
  # defp distance([head | tail], position = {:east, x, y}) do
  #   distance([head], position) + distance(tail, position)
  # end
  # defp distance([head | tail], position = {:south, x, y}) do
  #   distance([head], position) + distance(tail, position)
  # end
  # defp distance([head | tail], position = {:west, x, y}) do
  #   distance([head], position) + distance(tail, position)
  # end

  defp parse_step(<<char :: utf8>> <> steps_string) do
    {String.to_atom(String.downcase(List.to_string([char]))),
     String.to_integer(steps_string)}
  end

  defp parse_path(path_string) do
    path_string
    |> String.split(",")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_step/1)
  end
end
