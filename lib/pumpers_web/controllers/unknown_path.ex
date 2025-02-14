defmodule PumpersWeb.UnknownPath do
  use PumpersWeb, :controller
  # plug SaveRequest, "#{NaiveDateTime.add(NaiveDateTime.utc_now(), +5, :hour)}"
  alias PumpersWeb.Plugs.SaveRequest
  plug SaveRequest, stage: :final

  def unknown_path(%Plug.Conn{assigns: %{oid: oid}} = conn, _) do
    text(conn, "Unknown [path|request], but we have saved your request(#{oid}) for analysis! ;-)")
  end
end
