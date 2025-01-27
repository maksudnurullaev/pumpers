defmodule Pumpers.Repo.Migrations.AddObjectsIndexes do
  use Ecto.Migration

  def change do
    create index("logs", [:name, :oid, :field])
  end
end
