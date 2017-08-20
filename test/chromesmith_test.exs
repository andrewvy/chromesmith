defmodule ChromesmithTest do
  use ExUnit.Case
  doctest Chromesmith

  test "greets the world" do
    assert Chromesmith.hello() == :world
  end
end
