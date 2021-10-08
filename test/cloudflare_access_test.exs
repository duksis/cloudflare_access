defmodule CloudflareAccessTest do
  use ExUnit.Case
  import Mock
  doctest CloudflareAccess

  setup_with_mocks([
    {Application, [], [get_env: fn :cloudflare_access, :domain -> "duksis.lv" end]}
  ]) do
    :ok
  end

  test "domain not configured" do
    assert CloudflareAccess.domain() == "duksis.lv"
  end
end
