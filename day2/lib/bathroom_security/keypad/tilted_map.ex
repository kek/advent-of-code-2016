defmodule BathroomSecurity.Keypad.TiltedMap do
  @behaviour BathroomSecurity.Keypad.Map
  #     1
  #   2 3 4
  # 5 6 7 8 9
  #   A B C
  #     D
  def neighbor(f, "U") do
    case f do
      "3" -> "1"
      "6" -> "2"
      "7" -> "3"
      "8" -> "4"
      "A" -> "6"
      "B" -> "7"
      "C" -> "8"
      "D" -> "B"
      x -> x
    end
  end
  def neighbor(f, "D") do
    case f do
      "1" -> "3"
      "2" -> "6"
      "3" -> "7"
      "4" -> "8"
      "6" -> "A"
      "7" -> "B"
      "8" -> "C"
      "B" -> "D"
      x -> x
    end
  end
  def neighbor(f, "L") do
    case f do
      "3" -> "2"
      "4" -> "3"
      "6" -> "5"
      "7" -> "6"
      "8" -> "7"
      "9" -> "8"
      "B" -> "A"
      "C" -> "B"
      x -> x
    end
  end
  def neighbor(f, "R") do
    case f do
      "2" -> "3"
      "3" -> "4"
      "5" -> "6"
      "6" -> "7"
      "7" -> "8"
      "8" -> "9"
      "A" -> "B"
      "B" -> "C"
      x -> x
    end
  end
end
