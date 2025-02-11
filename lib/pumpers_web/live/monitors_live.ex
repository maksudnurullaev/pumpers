defmodule PumpersWeb.MonitorsLive do
  use PumpersWeb, :live_view
  # alias Pumpers.Accounts.Helper

  def render(assigns) do
    ~H"""
    <.header>
      Monitors <strong>{@monitors}</strong>
    </.header>
    """
  end

  def mount(_params, _session, socket) do
    # form = %{
    #   "users" => Helper.get_all_users_vs_role_id(),
    #   "roles" => Helper.get_all_roles_as_map()
    # }

    # {:ok, assign(socket, form: form)}
    {:ok, assign(socket, monitors: "mount")}
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
