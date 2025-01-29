defmodule Pumpers.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    field :admin, :boolean, default: false
    has_many :users, Pumpers.Accounts.User
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :admin])
    |> validate_required([:name, :admin])
    |> unique_constraint(:name)
  end
end
