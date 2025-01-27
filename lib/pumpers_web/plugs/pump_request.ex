defmodule PumpersWeb.Plugs.PumpRequest do
  import Plug.Conn

  # @locales ["en", "fr", "de"]

  def init(oid), do: oid

  # def call(%Plug.Conn{params: %{"locale" => loc}} = conn, _default) when loc in @locales do
  #   assign(conn, :locale, loc)
  # end

  def call(conn, _oid) do
    # assign(conn, :locale, default)
    oid = "#{NaiveDateTime.add(NaiveDateTime.utc_now(), +5, :hour)}"
    IO.puts("New log OID: #{oid}")
    save_req(conn, oid)
    assign(conn, :oid, oid)
  end

  def save_req(conn, oid) do
    {:ok, oid} = save_req_main(conn, oid)
    save_headers(conn, oid)
  end

  defp save_req_main(conn, oid) do
    alias Pumpers.{Repo, Log}

    assign(conn, :oid, oid)

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
