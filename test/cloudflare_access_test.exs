defmodule CloudflareAccessTest do
  use ExUnit.Case
  doctest CloudflareAccess

  test "greets the world" do
    assert CloudflareAccess.hello() == :world
  end
end
