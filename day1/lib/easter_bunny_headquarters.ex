defmodule EasterBunnyHeadquarters do
  defmodule Location do
    defstruct x: 0, y: 0
  end

  defmodule Position do
    defstruct direction: :north, location: %Location{}, trail: [%Location{}]
  end

  defmodule Movement do
    defstruct [:spin, :steps]
  end

  @doc """
  iex> distance_to_path("")
  0
  iex> distance_to_path("R1")
  1
  iex> distance_to_path("R1, L1")
  2
  iex> distance_to_path("R2, L3")
  5
  iex> distance_to_path("R2, R2, R2")
  2
  iex> distance_to_path("R5, L5, R5, R3")
  12
  iex> distance_to_path("L1, L1, L1, L1")
  0
  iex> distance_to_path("R1, R1, R1, R1")
  0
  iex> distance_to_path("R20, L1, L19, L2")
  2
  """
  def distance_to_path(path) when is_binary(path) do
    path
    |> parse_path
    |> destination
    |> Map.get(:location)
    |> distance_from_origin
  end

  defp distance_from_origin(nil), do: nil
  defp distance_from_origin(%Location{x: x, y: y}) do
    abs(x) + abs(y)
  end

  @doc """
  iex> distance_to_first_visited_twice("R1")
  nil
  iex> distance_to_first_visited_twice("R1, R1, R1, R1")
  0
  iex> distance_to_first_visited_twice("R2, R1, R1, R1, R1")
  1
  iex> distance_to_first_visited_twice("R8, R4, R4, R8")
  4
  """
  def distance_to_first_visited_twice(path) when is_binary(path) do
    path
    |> parse_path
    |> first_visited_twice
    |> distance_from_origin
  end

  defp first_visited_twice(path) do
    %Position{trail: trail} = destination(path)
    if Enum.uniq(trail) == trail do
      nil
    else
      Enum.reduce_while(trail, [], fn elem, acc ->
        if Enum.member?(acc, elem) do
          {:halt, elem}
        else
          {:cont, acc ++ [elem]}
        end
      end)
    end
  end

  defp destination(path), do: destination(%Position{}, path)
  defp destination(position = %Position{}, []), do: position
  defp destination(position = %Position{}, [%Movement{spin: spin, steps: steps} | rest]) do
    direction = turn(position.direction, spin)
    location = move(direction, position.location.x, position.location.y, steps)
    trail = position.trail ++ trail(position.location, location)
    destination(%Position{direction: direction, location: location, trail: trail}, rest)
  end

  defp trail(%Location{x: x, y: y}, %Location{x: x1, y: y1}) do
    {x, y} = cond do
      y == y1 and x1 > x -> {x + 1, y}
      y == y1 and x1 < x -> {x - 1, y}
      x == x1 and y1 > y -> {x, y + 1}
      x == x1 and y1 < y -> {x, y - 1}
      true -> {x, y}
    end
    for x <- x..x1, y <- y..y1 do
      %Location{x: x, y: y}
    end
  end

  defp turn(direction, :r) do
    case direction do
      :north -> :east
      :east -> :south
      :south -> :west
      :west -> :north
    end
  end
  defp turn(direction, :l) do
    case direction do
      :north -> :west
      :west -> :south
      :south -> :east
      :east -> :north
    end
  end

  defp move(:north, x, y, steps), do: %Location{x: x,         y: y + steps}
  defp move(:east, x, y, steps), do:  %Location{x: x + steps, y: y}
  defp move(:south, x, y, steps), do: %Location{x: x,         y: y - steps}
  defp move(:west, x, y, steps), do:  %Location{x: x - steps, y: y}

  defp parse_path(path_string) do
    path_string
    |> String.split(",")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_step/1)
  end

  defp parse_step(<<char :: utf8>> <> step_string) do
    spin = [char]
    |> List.to_string
    |> String.downcase
    |> String.to_atom
    steps = String.to_integer(step_string)
    %Movement{spin: spin, steps: steps}
  end
end
