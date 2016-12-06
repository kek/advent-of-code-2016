defmodule BathroomSecurity.Keypad.OrdinaryMap do
  @behaviour BathroomSecurity.Keypad.Map
  # 1 2 3
  # 4 5 6
  # 7 8 9
  def neighbor(f, "U") do
    case f do
      "4" -> "1"
      "5" -> "2"
      "6" -> "3"
      "7" -> "4"
      "8" -> "5"
      "9" -> "6"
      x -> x
    end
  end
  def neighbor(f, "D") do
    case f do
      "1" -> "4"
      "2" -> "5"
      "3" -> "6"
      "4" -> "7"
      "5" -> "8"
      "6" -> "9"
      x -> x
    end
  end
  def neighbor(f, "L") do
    case f do
      "2" -> "1"
      "3" -> "2"
      "5" -> "4"
      "6" -> "5"
      "8" -> "7"
      "9" -> "8"
      x -> x
    end
  end
  def neighbor(f, "R") do
    case f do
      "1" -> "2"
      "2" -> "3"
      "4" -> "5"
      "5" -> "6"
      "7" -> "8"
      "8" -> "9"
      x -> x
    end
  end
end
