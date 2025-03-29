defmodule PumpersWeb.MonitorLive.Index do
  use PumpersWeb, :live_view

  alias Pumpers.Monitors
  alias Pumpers.Monitors.Monitor

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :monitors, Monitors.list_monitors())}
  end

  # handle_event("cb_click", %{"id" => 1, "value" => "true"}
  # def handle_event("cb_click", %{"id" => id, "value" => _checked}, socket) do
  #   socket = assign_new(socket, :checked_monitors, fn -> [] end)
  #   socket = assign(socket, checked_monitors: [id | socket.assigns.checked_monitors])
  #   IO.puts(inspect(socket.assigns.checked_monitors))
  #   {:noreply, socket}
  # end

  @impl true
  def handle_event(action, params, socket) do
    socket =
      case action do
        "cb_click" ->
          handle_cb_click(params, socket)

        "delete" ->
          handle_delete(params, socket)

        _ ->
          IO.warn("Unknown action: #{action}")
          socket
      end

    {:noreply, socket}
  end

  def handle_cb_click(%{"id" => id} = params, socket) do
    IO.puts("XXX: #{inspect(params)}")
    socket = assign_new(socket, :checked_monitors, fn -> [] end)

    socket =
      if params["value"] do
        assign(socket, checked_monitors: [id | socket.assigns.checked_monitors])
      else
        assign(socket, checked_monitors: List.delete(socket.assigns.checked_monitors, id))
      end

    IO.puts(inspect(socket.assigns.checked_monitors))
    socket
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

  def handle_delete(%{"id" => id}, socket) do
    monitor = Monitors.get_monitor!(id)
    {:ok, _} = Monitors.delete_monitor(monitor)

    stream_delete(socket, :monitors, monitor)
  end
end
