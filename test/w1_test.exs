defmodule W1Test do
  use ExUnit.Case
  doctest W1

  test "greets the world" do
    assert W1.hello() == :world
  end
end
