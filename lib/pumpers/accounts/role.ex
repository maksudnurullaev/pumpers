defmodule Pumpers.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    field :is_admin, :boolean, default: false
    has_many :users, Pumpers.Accounts.User, foreign_key: :role_id
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :is_admin])
    |> validate_required([:name, :is_admin])
    |> unique_constraint(:name)
  end
end
