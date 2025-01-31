defmodule Pumpers.Repo.Migrations.AddPredefinedRoles do
  use Ecto.Migration
  alias Pumpers.Accounts.Role
  alias Pumpers.Repo

  def change do
    require Ecto.Query

    roles = [
      {"Registered Users", false},
      {"Powered Users", false},
      {"Administrators", true}
    ]

    Enum.each(roles, fn {role_name, is_admin} ->
      if Role |> Ecto.Query.where(name: ^role_name) |> Repo.exists?() do
        IO.puts("... ROLE: '#{role_name}' already exists!")
      else
        role_changeset =
          Role.changeset(%Role{}, %{
            name: role_name,
            admin: is_admin
          })

        Repo.insert(role_changeset)
        IO.puts("... ROLE: '#{role_name}' created!")
      end
    end)
  end
end
