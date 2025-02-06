defmodule Pumpers.Repo.Migrations.AddPredefinedRoles do
  use Ecto.Migration
  alias Pumpers.Accounts.Role
  alias Pumpers.Accounts.Helper
  alias Pumpers.Repo

  def change do
    require Ecto.Query

    roles = Helper.get_roles_map()

    Enum.each(roles, fn {role_name, is_admin} ->
      if Role |> Ecto.Query.where(name: ^role_name, is_admin: ^is_admin) |> Repo.exists?() do
        IO.puts("... ROLE: '#{role_name}' already exists!")
      else
        role_changeset =
          Role.changeset(%Role{}, %{
            name: role_name,
            is_admin: is_admin
          })

        Repo.insert(role_changeset)
        IO.puts("... ROLE: '#{role_name}', IS_ADMIN: '#{is_admin}' created!")
      end
    end)
  end
end
