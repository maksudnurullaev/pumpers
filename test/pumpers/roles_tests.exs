ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Pumpers.Repo, :manual)

defmodule Pumpers.RolesTests do
  alias Pumpers.Accounts
  use ExUnit.Case

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Pumpers.Repo)
  end

  describe "get_registered_users_role_id/0" do
    test "get registered users role field(:id) - valid" do
      assert Accounts.Helper.get_registered_users_role(:id)
    end

    test "get registered users role" do
      assert %Accounts.Role{} = Accounts.Helper.get_registered_users_role()
    end

    test "get registered users role field(:unknown) - invalid" do
      refute Accounts.Helper.get_registered_users_role(:unknown)
    end

  end
end
