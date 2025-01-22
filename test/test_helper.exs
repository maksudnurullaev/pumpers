ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Pumpers.Repo, :manual)

defmodule ObjectTest do
  # Once the mode is manual, tests can also be async
  # ADD , async: true
  use ExUnit.Case

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Pumpers.Repo)
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Pumpers.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    :ok
  end

  test "create simple object" do
    assert %Pumpers.Object{} =
             Pumpers.Repo.insert!(%Pumpers.Object{
               name: "name",
               oid: "oid",
               field: "field",
               value: "value"
             }),
           "Valid object"

    assert_raise Exqlite.Error, ~r/NOT NULL constraint/, fn ->
      %Pumpers.Object{} =
        Pumpers.Repo.insert!(%Pumpers.Object{name: "name", oid: "oid", field: "field"})
    end
  end
end
