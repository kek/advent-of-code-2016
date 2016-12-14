defmodule Monorail.Assembunny do
  def parse(source_code) do
    source_code
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn line ->
         line
         |> String.split
         |> Enum.map(&atomize/1)
       end)
  end

  defp atomize(string) do
    if !String.match?(string, ~r/[0-9]+/) do
      String.to_atom(string)
    else
      String.to_integer(string)
    end
  end
end
