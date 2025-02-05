defmodule Pumpers.Repo.Migrations.ChangeRolesAdminFieldRename do
  use Ecto.Migration

  def change do
      rename table("roles"), :admin, to: :is_admin
  end
end
