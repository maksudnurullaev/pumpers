defmodule PumpersWeb.NotFound do
  use PumpersWeb, :controller

  def not_found(conn, _) do
    text(conn, "Page not found, but we have recorded your request! ;-)")
  end
end
