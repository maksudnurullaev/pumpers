defmodule PumpersWeb.AdminUsersLive do
  use PumpersWeb, :live_view

  def render(assigns) do
    ~H"""
    Current temperature: {@temperature}°F
    <button phx-click="inc_temperature">+</button>
    """
  end

  def mount(_params, _session, socket) do
    temperature = 70 # Let's assume a fixed temperature for now
    IO.inspect(socket.assigns)
    {:ok, assign(socket, :temperature, temperature)}
  end

  def handle_event("inc_temperature", _params, socket) do
    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end
end
