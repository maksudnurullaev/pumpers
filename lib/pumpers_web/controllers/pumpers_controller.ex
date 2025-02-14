defmodule PumpersWeb.PumpersController do
  use PumpersWeb, :controller

  def home(conn, _params) do
    conn
    |> render(:home)
  end

  def index(conn, _params) do
    conn
    |> render(:index)
  end

  def show(conn, %{"messenger" => messenger}) do
    render(conn, :show, messenger: messenger)
  end
end
