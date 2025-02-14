defmodule Pumpers.LogsHelper do
  import Ecto.Query, warn: false
  alias Pumpers.Log
  alias Pumpers.Repo

  @default_log_name "REQUEST"
  @request_headers_fields ["REQUEST", "HEADER", "BODY", "PARAMETERS"]

  def get_logs(%{
        "page" => _page,
        "pages" => _pages,
        "page_size" => _page_size,
        "search_text" => search_text
      }) do
    q =
      if(search_text) do
        search_text = "%#{search_text}%"

        from l in Log,
          order_by: [desc: l.id],
          where: l.name == @default_log_name and ilike(l.value, ^search_text),
          select: %{id: l.id, name: l.name, oid: l.oid, value: l.value}
      else
        from l in Log,
          order_by: [desc: l.id],
          where: l.name == @default_log_name,
          select: %{id: l.id, name: l.name, oid: l.oid, value: l.value}
      end

    Repo.all(q)
  end

  # def get_log_by_name() do
  #   q =
  #     from l in Log,
  #       order_by: [desc: l.id],
  #       where: [name: @default_log_name],
  #       select: %{id: l.id, field: l.field, oid: l.oid, value: l.value}

  #   Repo.all(q)
  #   # r = Log |> first() |> Repo.one()
  #   # [r]
  # end

  def get_log_details(oid) do
    oid = URI.decode(oid)

    q =
      from l in Log,
        where: l.oid == ^oid and l.name in @request_headers_fields,
        select: %{field: l.field, value: l.value}

    Repo.all(q)
  end
end
