defmodule PumpersWeb.MonitorsLive do
  use PumpersWeb, :live_view
  import PumpersWeb.Components.Monitors

  @modes [:list, :edit, :add]

  def render(assigns) do
    ~H"""
    <%= case assigns.mode do %>
      <% :list -> %>
        <.monitor_list />
      <% _ -> %>
        <.monitor_form monitor={assigns.monitor} />
    <% end %>
    """
  end

  def is_mode?(mode, assigns) when is_atom(mode) and mode in @modes do
    assigns.mode == mode
  end

  def mount(_params, _session, socket) do
    monitor = %{
      "protocol" => "HTTP",
      "method" => "GET",
      "url" => "",
      "result" => ""
    }

    {:ok, assign(socket, monitor: monitor, mode: :list)}
    # {:ok, assign(socket, monitors: "mount")}
  end

  def handle_event("add_monitor_form", _params, socket) do
    {:noreply, update(socket, :mode, &(&1 = :add))}
  end

  def handle_event("list_monitors", _params, socket) do
    {:noreply, update(socket, :mode, &(&1 = :list))}
  end

  # def handle_event(
  #       "change_role",
  #       %{"user_id" => user_id, "user_role_id_new" => user_role_id_new},
  #       socket
  #     ) do
  #   if Helper.user_is_valid_by_update_at?(socket.assigns[:current_user]) do
  #     Helper.change_user_role(user_id, user_role_id_new)
  #     socket = put_flash(socket, :info, "Role changed!")
  #     form = Map.put(socket.assigns.form, "users", Helper.get_all_users_vs_role_id())
  #     {:noreply, update(socket, :form, &(&1 = form))}
  #   else
  #     socket = put_flash(socket, :error, "User does not have proper rights!")
  #     {:noreply, redirect(socket, to: ~p"/")}
  #   end
  # end
end
