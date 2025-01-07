defmodule Pumpers.Repo do
  use Ecto.Repo,
    otp_app: :pumpers,
    adapter: Ecto.Adapters.SQLite3
end
