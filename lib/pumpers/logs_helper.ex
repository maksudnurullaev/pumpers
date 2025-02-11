defmodule Pumpers.LogsHelper do
  import Ecto.Query, warn: false
  alias Pumpers.Log
  alias Pumpers.Repo

  @default_log_name "REQUEST"

  def get_log_by_name(name \\ @default_log_name) when is_binary(name) do
    q =
      from l in Log,
        order_by: [desc: l.id],
        where: [name: ^name],
        select: %{id: l.id, field: l.field, oid: l.oid, value: l.value}
    Repo.all(q)
    # r = Log |> first() |> Repo.one()
    # [r]
  end

  def get_log_details(oid) do
    oid = URI.decode(oid)
    q =
      from l in Log,
        where: [oid: ^oid],
        select: %{field: l.field, value: l.value}
    Repo.all(q)
  end
end
