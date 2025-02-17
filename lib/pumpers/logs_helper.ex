defmodule Pumpers.LogsHelper do
  import Ecto.Query, warn: false
  alias Pumpers.Log
  alias Pumpers.Repo
  alias PumpersWeb.Utils

  @default_log_name "REQUEST"
  @request_headers_fields ["REQUEST", "HEADER", "BODY", "PARAMETERS"]

  def get_logs(
        %{
          "page" => _page,
          "pages" => _pages,
          "page_size" => _page_size,
          "search_path" => search_path,
          "search_text" => _search_text
        } = toolbar
      ) do
    q =
      if(not Utils.string_nil_or_empty?(search_path)) do
        search_path = "%#{String.trim(search_path)}%"

        from l in Log,
          order_by: [desc: l.id],
          where: l.name == @default_log_name and like(l.value, ^search_path)
      else
        from l in Log,
          order_by: [desc: l.id],
          where: l.name == @default_log_name
      end

    counter = Repo.aggregate(q, :count)
    toolbar = Map.put(toolbar, "count", to_string(counter))
    {limit, offset, pages} = Utils.get_limit_offset(toolbar)
    toolbar = Map.put(toolbar, "pages", to_string(pages))

    q =
      from l in q,
        select: %{id: l.id, name: l.name, oid: l.oid, value: l.value},
        limit: ^limit,
        offset: ^offset

    {:ok, Repo.all(q), toolbar}
  end

  def get_log_details(oid) do
    oid = URI.decode(oid)

    q =
      from l in Log,
        where: l.oid == ^oid and l.name in @request_headers_fields,
        select: %{field: l.field, value: l.value}

    Repo.all(q)
  end
end
