defmodule Pumpers.Repo.Migrations.ModifyMonitors do
  use Ecto.Migration

  def change do
    alter table(:monitors) do
      add :status_code, :integer
    end

    rename table("monitors"), :result, to: :response
  end
end
