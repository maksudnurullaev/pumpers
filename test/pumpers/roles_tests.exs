ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Pumpers.Repo, :manual)

defmodule Pumpers.RolesTests do
  alias Pumpers.Accounts
  use ExUnit.Case

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Pumpers.Repo)
  end

  describe "test_roles" do
    role_names = Accounts.Helper.get_all_roles_names()

    Enum.each(role_names, fn role_name ->
      test "get #{role_name} role" do
        role = Accounts.Helper.get_role_or_field(unquote(role_name), nil)
        assert %Accounts.Role{} = role
        assert unquote(role_name) == role.name
      end
    end)

    test "get registered users role field(:id) - valid" do
      assert Accounts.Helper.get_registered_role_or_field(:id)
    end

    test "get registered users role" do
      assert %Accounts.Role{} = Accounts.Helper.get_registered_role_or_field()
    end

    test "get registered users role field(:unknown) - invalid" do
      refute Accounts.Helper.get_registered_role_or_field(:unknown)
    end

    test "get unknown role" do
      assert_raise RuntimeError, "Role 'Unknown Role' not found", fn ->
        Accounts.Helper.get_role_or_field("Unknown Role", nil)
      end
    end

    test "get unknown field" do
      refute Accounts.Helper.get_registered_role_or_field(:unknown_field)
    end
  end
end
