defmodule Pumpers.Repo.Migrations.CreateObjects do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :name, :string, null: false
      add :oid, :string, null: false
      add :field, :string, null: false
      add :value, :string, null: false, collate: :nocase
    end
  end
end
