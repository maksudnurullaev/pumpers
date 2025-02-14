# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pumpers.Repo.insert!(%Pumpers.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule SeedHelper do
  alias Pumpers.Accounts.Role
  alias Pumpers.Repo

  defmacro macro_check_and_insert_role(role_name, is_admin) do
    quote do
      require Ecto.Query

      if(Role |> Ecto.Query.where(name: ^unquote(role_name)) |> Repo.exists?()) do
        IO.puts("... ROLE: '#{unquote(role_name)}' already exists!")
      else
        role_changeset =
          Pumpers.Accounts.Role.changeset(%Pumpers.Accounts.Role{}, %{
            name: unquote(role_name),
            is_admin: unquote(is_admin)
          })

        Pumpers.Repo.insert(role_changeset)
        IO.puts("... ROLE: '#{unquote(role_name)}' created!")
      end
    end
  end

  def check_and_insert_role(role_name, is_admin) do
    require Ecto.Query

    if(Role |> Ecto.Query.where(name: ^role_name) |> Repo.exists?()) do
      IO.puts("... ROLE: '#{role_name}' already exists!")
    else
      role_changeset =
        Pumpers.Accounts.Role.changeset(%Pumpers.Accounts.Role{}, %{
          name: role_name,
          is_admin: is_admin
        })

      Pumpers.Repo.insert(role_changeset)
      IO.puts("... ROLE: '#{role_name}' created!")
    end
  end
end

defmodule Seeds do
  alias Pumpers.Accounts.Helper
  require SeedHelper

  def go do
    roles = Helper.get_roles_map()

    Enum.map(roles, fn {role_name, is_admin} ->
      SeedHelper.check_and_insert_role(role_name, is_admin)
      # IO.puts("... ROLE: '#{role_name}' - #{is_admin}")
    end)
  end
end

Seeds.go()
