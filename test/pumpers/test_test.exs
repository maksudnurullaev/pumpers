defmodule AssertionTest do
  use ExUnit.Case

  setup %{login_as: username} do
    {:ok, current_user: username}
  end

  @tag login_as: "max"
  test "tags modify context", context do
    assert context[:login_as] == "max"
    assert context[:current_user] == "max"
  end
end
