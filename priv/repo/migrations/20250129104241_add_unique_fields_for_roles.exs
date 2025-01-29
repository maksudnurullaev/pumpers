defmodule Pumpers.Repo.Migrations.AddUniqueFieldsForRoles do
  use Ecto.Migration

  def change do
    create unique_index(:roles, [:name])
  end
end
