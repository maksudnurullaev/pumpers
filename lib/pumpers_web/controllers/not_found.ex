defmodule PumpersWeb.NotFound do
  use PumpersWeb, :controller
  # plug PumpRequest, "#{NaiveDateTime.add(NaiveDateTime.utc_now(), +5, :hour)}"
  alias PumpersWeb.Plugs.PumpRequest
  plug PumpRequest

  def not_found(conn, _) do
    text(conn, "Page not found, but we have saved your request for analysis! ;-)")
  end
end
