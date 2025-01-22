defmodule Pumpers.Repo.Migrations.CreateObjects do
  use Ecto.Migration

  def change do
    create table(:objects) do
      add :name, :string, null: false
      add :oid, :string, null: false
      add :field, :string, null: false
      add :value, :string, null: false, collate: :nocase

      # timestamps(type: :utc_datetime)
    end
  end
end
