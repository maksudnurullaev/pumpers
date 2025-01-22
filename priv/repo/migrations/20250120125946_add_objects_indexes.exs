defmodule Pumpers.Repo.Migrations.AddObjectsIndexes do
  use Ecto.Migration

  def change do
    create index("objects", [:name, :oid, :field])
  end
end
