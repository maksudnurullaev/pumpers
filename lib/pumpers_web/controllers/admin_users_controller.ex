defmodule PumpersWeb.AdminUsersController do
  use PumpersWeb, :controller

  require Plug.Conn
  alias Pumpers.AdminUsers

  def index(conn, _params) do
    users = AdminUsers.list_users()
    roles = get_all_roles_for_selection()
    render(conn, :index, users: users, roles: roles)
  end

  # def new(conn, _params) do
  #   changeset = AdminUsers.change_user(%User{})
  #   render(conn, :new, changeset: changeset)
  # end

  # def create(conn, %{"user" => user_params}) do
  #   case AdminUsers.create_user(user_params) do
  #     {:ok, user} ->
  #       conn
  #       |> put_flash(:info, "User created successfully.")
  #       |> redirect(to: ~p"/users/#{user}")

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, :new, changeset: changeset)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   user = AdminUsers.get_user!(id)
  #   render(conn, :show, user: user)
  # end

  # def edit(conn, %{"id" => id}) do
  #   user = AdminUsers.get_user!(id)
  #   roles = get_all_roles_for_selection()
  #   changeset = AdminUsers.changeset_role(user, %{"id" => id})

  #   conn
  #   |> assign(:user, user)
  #   |> assign(:roles, roles)
  #   |> assign(:changeset, changeset)
  #   |> render(:edit)
  # end

  # def get_all_roles(conn, _params) do
  defp get_all_roles_for_selection() do
    Pumpers.Accounts.Role |> Pumpers.Repo.all() |> Enum.map(&{&1.name, &1.id})
  end

  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = AdminUsers.get_user!(id)

  #   case AdminUsers.update_user(user, user_params) do
  #     {:ok, user} ->
  #       conn
  #       |> put_flash(:info, "User updated successfully.")
  #       |> redirect(to: ~p"/users/#{user}")

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, :edit, user: user, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   user = AdminUsers.get_user!(id)
  #   {:ok, _user} = AdminUsers.delete_user(user)

  #   conn
  #   |> put_flash(:info, "User deleted successfully.")
  #   |> redirect(to: ~p"/users")
  # end
end
