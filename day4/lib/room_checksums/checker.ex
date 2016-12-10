defmodule RoomChecksums.Checker do
  @doc """
  iex> real?("aaaaa-bbb-z-y-x-123[abxyz]")
  true # is a real room because the most common letters are a (5), b (3), and then a tie between x, y, and z, which are listed alphabetically.
  iex> real?("a-b-c-d-e-f-g-h-987[abcde]")
  true # is a real room because although the letters are all tied (1 of each), the first five are listed alphabetically.
  iex> real?("not-a-real-room-404[oarel]")
  true # is a real room.
  iex> real?("totally-real-room-200[decoy]")
  false # is not.
  """
  def real?(room) do
    {encrypted_name, _, checksum} = split_room_name(room)
    most_common_letters(encrypted_name, 5) == checksum
  end

  @doc """
  iex> real_room_sector_id_sum("aaaaa-bbb-z-y-x-123[abxyz] a-b-c-d-e-f-g-h-987[abcde] not-a-real-room-404[oarel] totally-real-room-200[decoy]")
  1514
  """
  def real_room_sector_id_sum(input) do
    input
    |> String.split
    |> Enum.filter(&real?/1)
    |> Enum.map(&split_room_name/1)
    |> Enum.map(fn {_, id, _} -> id end)
    |> Enum.sum
  end

  def print_unencrypted_room_names(input) do
    input
    |> String.split
    |> Enum.filter(&real?/1)
    |> Enum.each(fn room ->
         {encrypted_name, id, _} = split_room_name(room)
         room_name = decrypt_room_name(room)
         IO.puts "#{id} - #{encrypted_name} - #{room_name}"
       end)
  end

  @doc """
  iex> split_room_name("aaaaa-bbb-z-y-x-123[abxyz]")
  {"aaaaa-bbb-z-y-x", 123, "abxyz"}
  """
  def split_room_name(room) do
    regex = ~r/([a-z-]*)-([0-9]*)\[([a-z]*)\]/
    [_, encrypted_name, id, checksum] = Regex.run(regex, room)

    {encrypted_name, String.to_integer(id), checksum}
  end

  @doc """
  iex> letters("a-b-c")
  "abc"
  """
  def letters(string) do
    string
    |> String.codepoints
    |> Enum.filter(&Regex.match?(~r/[a-z]/, &1))
    |> Enum.join
  end

  @doc """
  iex> most_common_letters("a", 1)
  "a"
  iex> most_common_letters("abcdefghij", 5)
  "abcde"
  iex> most_common_letters("aaaaa-bbb-z-y-x", 5)
  "abxyz"
  iex> most_common_letters("abbcde", 5)
  "bacde"
  """
  def most_common_letters(string, number) do
    letters = string
    |> String.codepoints
    |> Enum.reject(&(&1 == "-"))

    mapper = fn letter ->
      {letter, Enum.count(letters, &(&1 == letter))}
    end

    sorter = fn
      {letter1, frequency}, {letter2, frequency} ->
        letter1 <= letter2
      {_, frequency}, {_, frequency2} ->
        frequency >= frequency2
    end

    letters
    |> Enum.uniq
    |> Enum.sort_by(mapper, sorter)
    |> Enum.take(number)
    |> Enum.join
  end

  @doc """
  iex> decrypt_room_name("qzmt-zixmtkozy-ivhz-343[zimth]")
  "very encrypted name"
  """
  def decrypt_room_name(room) do
    {encrypted_name, id, _} = split_room_name(room)
    encrypted_name
    |> String.codepoints
    |> Enum.map(&(rotate(&1, id)))
    |> Enum.join
  end

  @doc """
  iex> rotate("a", 0)
  "a"
  iex> rotate("a", 1)
  "b"
  """
  def rotate(c, 0), do: c
  def rotate(c, times) do
    c = case c do
          " " -> " "
          "-" -> " "
          "z" -> "a"
          << p >> -> << p + 1 >>
    end
    rotate(c, times - 1)
  end
end
