defmodule PumpersWeb.MonitorsController do
  use PumpersWeb, :controller

  def index(conn, _params) do
    conn
    |> render(:index)
  end

  def show(conn, %{"id" => id}) do
    render(conn, :show, id: id)
  end
end
