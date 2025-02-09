defmodule PumpersWeb.AdminUsersLive do
  use PumpersWeb, :live_view
  alias Pumpers.Accounts.Helper

  def render(assigns) do
    ~H"""
    <.header>
      Listing Users
    </.header>

    <.table id="users" rows={@form["users"]}>
      <%!-- _row_click={&JS.navigate(~p"/admin/users/#{&1}/edit")}> --%>
      <:col :let={user} label="#ID">{user.id}</:col>
      <:col :let={user} label="Name">{user.email}</:col>
      <%!-- <:col :let={user} label="Role ID">{user.role_id}</:col> --%>
      <:col :let={user} label="Role">
        <%= if user.id == @current_user.id do %>
          <strong>{user.role}</strong>
        <% else %>
          <.form
            for={@form}
            phx-change="change_role"
            phx-value-user_id={user.id}
            phx-value-user_role_id_old={user.role_id}
          >
            <.input
              id={"user_id_#{user.id}__role_change"}
              name="user_role_id_new"
              value={user.role_id}
              type="select"
              options={@form["roles"]}
            />
          </.form>
        <% end %>
      </:col>
    </.table>
    """
  end

  def mount(_params, _session, socket) do
    form = %{
      "users" => Helper.get_all_users_vs_role_id(),
      "roles" => Helper.get_all_roles_as_map()
    }

    {:ok, assign(socket, form: form)}
  end

  def handle_event(
        "change_role",
        %{"user_id" => user_id, "user_role_id_new" => user_role_id_new},
        socket
      ) do
    Helper.change_user_role(user_id, user_role_id_new)

    form = Map.put(socket.assigns.form, "users", Helper.get_all_users_vs_role_id())
    socket = put_flash(socket, :info, "Role changed!")
    {:noreply, update(socket, :form, &(&1 = form))}
  end
end
