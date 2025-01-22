defmodule PumpersWeb.PumpersController do
  use PumpersWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # render(conn, :home, layout: false)
    conn
    # , layout: false)
    |> render(:home)
  end

  def index(conn, _params) do
    conn
    # |> put_root_layout(html: false)
    |> render(:index)
  end

  def show(conn, %{"messenger" => messenger}) do
    render(conn, :show, messenger: messenger)
    # text(conn, "From messenger #{messenger}")
    # json(conn, %{id: "From messenger #{messenger}"})
  end
end
