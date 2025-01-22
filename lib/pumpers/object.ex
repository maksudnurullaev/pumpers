defmodule Pumpers.Object do
  use Ecto.Schema
  import Ecto.Changeset

  schema "objects" do
    field :name, :string
    field :value, :string
    field :field, :string
    field :oid, :string

    #timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(object, attrs) do
    object
    |> cast(attrs, [:name, :oid, :field, :value])
    |> validate_required([:name, :oid, :field, :value])
  end
end
