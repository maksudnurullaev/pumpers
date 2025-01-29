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

admin_role = Pumpers.Accounts.Role.changeset(%Pumpers.Accounts.Role{}, %{name: "Administrators", admin: true})
user_role = Pumpers.Accounts.Role.changeset(%Pumpers.Accounts.Role{}, %{name: "Registered Users", admin: false})
roles = [admin_role, user_role]
Enum.each(roles, fn role ->
  case Pumpers.Repo.insert(role) do
    {:ok, _role} ->
      IO.puts("#{role.changes.name} role created")
    {:error, changeset} ->
      IO.puts("... WARN: role '#{changeset.changes.name}' already exists!")
  end
end)
