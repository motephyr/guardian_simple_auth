defmodule GuardianSimpleAuthTest do
  use ExUnit.Case
  doctest GuardianSimpleAuth

  test "greets the world" do
    assert GuardianSimpleAuth.hello() == :world
  end
end
