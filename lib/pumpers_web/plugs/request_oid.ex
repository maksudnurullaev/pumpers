defmodule PumpersWeb.Plugs.RequestOId do
  import Plug.Conn

  def init(oid) when not is_nil(oid), do: oid

  def call(conn, oid) do
    assign(conn, :row_oid, oid)
  end
end
