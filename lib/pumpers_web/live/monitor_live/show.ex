defmodule PumpersWeb.MonitorLive.Show do
  use PumpersWeb, :live_view

  alias Pumpers.Monitors
  alias Pumpers.Utils.Monitoring

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:monitor, Monitors.get_monitor!(id))}
  end

  defp page_title(:show), do: "Show Monitor"
  defp page_title(:edit), do: "Edit Monitor"

  @impl true
  def handle_event("test_monitor", %{"id" => id}, socket) do
    case Monitoring.test_monitor(Monitors.get_monitor!(id)) do
      {:ok, result} ->
        {:noreply, socket |> assign(:result, "#{inspect(result)}")}

      {:error, reason} ->
        {:noreply, socket |> assign(:result, "Error: #{reason}")}
    end
  end
end
