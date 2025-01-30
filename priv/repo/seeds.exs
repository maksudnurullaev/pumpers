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

  defmacro check_and_insert_role(role_name, admin_status) do
    quote do
      require Ecto.Query

      if(Role |> Ecto.Query.where(name: unquote(role_name)) |> Repo.exists?()) do
        IO.puts("... ROLE: '#{unquote(role_name)}' already exists!")
      else
        role_changeset =
          Pumpers.Accounts.Role.changeset(%Pumpers.Accounts.Role{}, %{
            name: unquote(role_name),
            admin: unquote(admin_status)
          })

        Pumpers.Repo.insert(role_changeset)
        IO.puts("... ROLE: '#{unquote(role_name)}' created!")
      end
    end
  end
end

defmodule Seeds do
  require SeedHelper

  def go do
    SeedHelper.check_and_insert_role("Registered Users", false)
    SeedHelper.check_and_insert_role("Powered Users", false)
    SeedHelper.check_and_insert_role("Administrators", true)
  end
end

Seeds.go()
