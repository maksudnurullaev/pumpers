defmodule PumpersWeb.MonitorLive.Index do
  use PumpersWeb, :live_view

  alias Pumpers.Monitors
  alias Pumpers.Monitors.Monitor

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :monitors, Monitors.list_monitors())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Monitor")
    |> assign(:monitor, Monitors.get_monitor!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Monitor")
    |> assign(:monitor, %Monitor{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Monitors")
    |> assign(:monitor, nil)
  end

  @impl true
  def handle_info({PumpersWeb.MonitorLive.FormComponent, {:saved, monitor}}, socket) do
    {:noreply, stream_insert(socket, :monitors, monitor)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    monitor = Monitors.get_monitor!(id)
    {:ok, _} = Monitors.delete_monitor(monitor)

    {:noreply, stream_delete(socket, :monitors, monitor)}
  end
end
