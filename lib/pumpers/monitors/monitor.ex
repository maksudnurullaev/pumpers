defmodule Pumpers.Monitors.Monitor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "monitors" do
    field :url, :string
    field :method, Ecto.Enum, values: [:get, :post], default: :get
    field :post_data, :string
    # Response from the server
    field :status_code, :integer
    field :response, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(monitor, attrs) do
    monitor
    |> cast(attrs, [:url, :method, :post_data, :status_code, :response])
    |> validate_required([:url, :method])
    |> validate_post_data()
  end

  defp validate_post_data(changeset) do
    case get_field(changeset, :method) do
      :post ->
        case get_field(changeset, :post_data) do
          nil -> add_error(changeset, :post_data, "is required for POST requests")
          "" -> add_error(changeset, :post_data, "is required for POST requests")
          _ -> changeset
        end
      _ -> changeset
    end
  end
end
