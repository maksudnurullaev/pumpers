defmodule Pumpers.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :name, :string
    field :value, :string
    field :field, :string
    field :oid, :string
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:name, :oid, :field, :value])
    |> validate_required([:name, :oid, :field, :value])
  end
end
