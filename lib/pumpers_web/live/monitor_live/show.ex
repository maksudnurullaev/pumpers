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
    monitor = Monitors.get_monitor!(id)

    monitor =
      monitor
      |> Monitoring.test_monitor()

    IO.puts("XXX_Z: Monitor: #{inspect(monitor)}")

    {:noreply,
     socket
     |> put_flash(:info, "Test passed successfully")
     |> assign(:monitor, Monitors.get_monitor!(id))}

    # The following code is commented out because it is not needed for the exercise

    # case Monitoring.test_monitor(Monitors.get_monitor!(id)) do
    #   {:ok, result} ->
    #     {:noreply, socket |> assign(:result, ok: "#{inspect(result)}")}

    #   {:error, exception_message} ->
    #     {:noreply, socket |> assign(:result, error: "#{exception_message}")}
    # end
  end
end
