defmodule CloudflareAccessTest do
  use ExUnit.Case
  doctest CloudflareAccess

  test "domain not configured" do
    assert CloudflareAccess.domain() == "duksis.lv"
  end
end
