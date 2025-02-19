defmodule PumpersWeb.MonitorsLive do
  alias PumpersWeb.Utils
  use PumpersWeb, :live_view
  import PumpersWeb.Components.Monitors

  @modes [:list, :edit, :add]

  def render(assigns) do
    ~H"""
    <%= case assigns.mode do %>
      <% :list -> %>
        <.monitor_list />
      <% _ -> %>
        <.monitor_form monitor={assigns.monitor} errors={assigns.errors} />
    <% end %>
    """
  end

  def is_mode?(mode, assigns) when is_atom(mode) and mode in @modes do
    assigns.mode == mode
  end

  def mount(_params, _session, socket) do
    monitor = %{"method" => "GET", "url" => "", "post_data" => "", "result" => ""}

    errors = %{"url" => []}
    {:ok, assign(socket, monitor: monitor, mode: :add, errors: errors)}
  end

  def handle_event("validate_url", %{"value" => url_string} = _params, socket) do
    monitor = Map.put(socket.assigns.monitor, "url", url_string)

    case Utils.is_valid_url?(url_string) do
      {:ok, _uri} ->
        errors = Map.put(socket.assigns.errors, "url", [])
        {:noreply, socket |> update(:monitor, &(&1 = monitor)) |> update(:errors, &(&1 = errors))}

      {:error, _} ->
        errors = Map.put(socket.assigns.errors, "url", ["Invalid URL"])
        {:noreply, socket |> update(:monitor, &(&1 = monitor)) |> update(:errors, &(&1 = errors))}
    end
  end

  def handle_event("set_method", %{"method" => method}, socket) do
    monitor = Map.put(socket.assigns.monitor, "method", method)
    {:noreply, update(socket, :monitor, &(&1 = monitor))}
  end

  def handle_event("add_monitor_form", _params, socket) do
    {:noreply, update(socket, :mode, &(&1 = :add))}
  end

  def handle_event("list_monitors", _params, socket) do
    {:noreply, update(socket, :mode, &(&1 = :list))}
  end
end
