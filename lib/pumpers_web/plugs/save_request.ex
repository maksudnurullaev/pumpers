defmodule PumpersWeb.Plugs.SaveRequest do
  import Plug.Conn

  @re_ct_json ~r/json$/i

  def init(opts), do: opts

  def call(%Plug.Conn{} = conn, _opts) do
    oid = "#{NaiveDateTime.add(NaiveDateTime.utc_now(), +5, :hour)}"

    save_request(conn, oid)

    save_headers(conn, oid)
    save_parametes(conn, oid)
    if json_request?(conn), do: save_body(conn, oid)

    assign(conn, :oid, oid)
  end

  defp json_request?(conn) do
    conn.req_headers
    |> List.keyfind("content-type", 0)
    |> case do
      {_, content_type} ->
        Regex.match?(@re_ct_json, content_type)

      _ ->
        false
    end
  end

  defp save_parametes(conn, oid) do
    alias Pumpers.{Repo, Log}

    params = inspect(conn.params)

    o =
      %Log{
        oid: oid,
        name: "PARAMETERS",
        field: "PARAMETERS",
        value: params
      }

    Repo.insert(o)
  end

  defp save_body(conn, oid) do
    alias Pumpers.{Repo, Log}

    body =
      if(conn.assigns[:raw_body]) do
        inspect(conn.assigns[:raw_body])
      else
        {:ok, body, _conn} = Plug.Conn.read_body(conn)
        inspect(body)
      end

    o =
      %Log{
        oid: oid,
        name: "BODY",
        field: "BODY",
        value: body
      }

    Repo.insert(o)
  end

  defp save_request(conn, oid) do
    alias Pumpers.{Repo, Log}

    qs =
      if(String.length(conn.query_string) > 0,
        do: "#{conn.request_path}?#{conn.query_string}",
        else: conn.request_path
      )

    o = %Log{
      name: "REQUEST",
      field: "[HOST]:[METHOD]:[PATH]",
      oid: oid,
      value: "[#{conn.host}]:[#{conn.method}]:[#{qs}]"
    }

    Repo.insert!(o)

    {:ok, oid}
  end

  defp save_headers(conn, oid) do
    alias Pumpers.{Repo, Log}

    headers = conn.req_headers

    oo =
      headers
      |> Enum.map(fn kv ->
        %Log{
          oid: oid,
          name: "HEADER",
          field: elem(kv, 0),
          value: elem(kv, 1)
        }
      end)

    Enum.each(oo, fn o -> Repo.insert(o) end)

    {:ok, length(oo)}
  end
end
