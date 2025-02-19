defmodule Pumpers.Repo.Migrations.CreateMonitors do
  use Ecto.Migration

  def change do
    create table(:monitors) do
      add :url, :string
      add :method, :string
      add :post_data, :string
      add :result, :string

      timestamps(type: :utc_datetime)
    end
  end
end
