defmodule BathroomSecurity.Keypad.Map do
  @type finger :: String.t
  @type direction :: String.t
  @callback neighbor(finger(), direction()) :: finger()
end
