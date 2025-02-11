defmodule PumpersWeb.AdminUserControllerTest do
  alias Pumpers.Accounts.User
  alias Pumpers.Accounts.Helper
  use PumpersWeb.ConnCase

  import Pumpers.AccountsFixtures
  import Pumpers.Accounts.Helper

  setup do
    %{user: user_fixture()}
  end

  describe "access_to_admin_pages" do
    test "could not access to admin pages withouf login", %{conn: conn} do
      conn = get(conn, ~p"/admin/users/live")

      assert conn.halted
      assert redirected_to(conn) == ~p"/users/log_in"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) ==
               "You must log in to access this page."
    end

    test "access admin's pages - success with Administrator role", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      assert is_administrator?(user)
      assert 1 == Helper.count_of(User)
      assert conn = get(conn, ~p"/admin/users/live")
      assert html_response(conn, 200) =~ "Listing Users"
    end

    test "access admin's pages - failed without Administrator role", %{conn: conn} do
      %{conn: conn, user: user} = register_and_log_in_user(%{conn: conn})
      refute is_administrator?(user)

      assert conn = get(conn, ~p"/admin/users/live")
      assert conn.halted

      assert Phoenix.Flash.get(conn.assigns.flash, :error) ==
               "You must log in as 'Administrator'!"

      assert html_response(conn, 302) =~ "redirected"
    end
  end
end
