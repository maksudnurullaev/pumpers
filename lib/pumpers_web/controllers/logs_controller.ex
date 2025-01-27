defmodule PumpersWeb.LogsController do
  use PumpersWeb, :controller

  def index(conn, _params) do
    conn
    |> put_layout(html: :logs)
    |> render(:index)
  end

  def show(conn, %{"id" => id}) do
    render(conn, :show, id: id)
  end
end
