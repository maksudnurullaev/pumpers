defmodule PumpersWeb.AdminUsersLive do
  use PumpersWeb, :live_view
  alias Pumpers.Accounts.Helper

  def render(assigns) do
    ~H"""
    <.header>
      Listing Users
      <%!-- <:actions>
    <.link href={~p"/users/new"}>
      <.button>New User</.button>
    </.link>
    </:actions> --%>
    </.header>

    <.table id="users" rows={@form["users"]}>
      <%!-- _row_click={&JS.navigate(~p"/admin/users/#{&1}/edit")}> --%>
      <:col :let={user} label="#ID">{user.id}</:col>
      <:col :let={user} label="Name">{user.email}</:col>
      <:col :let={user} label="Role">
        <%= if user.id == @current_user.id do %>
          <strong>{user.role}</strong>
        <% else %>
          <.form
            for={@form}
            phx-change="change_role"
            phx-value-user_id={user.id}
            phx-value-user_role_id={user.role_id}
          >
            <.input
              id={"user_id_#{user.id}__role_change"}
              name="user_role_id_old"
              phx-var-user_role_id_old={user.role_id}
              value={user.role_id}
              type="select"
              options={@form["roles"]}
            />
          </.form>
        <% end %>
      </:col>

      <%!-- <:action :let={user}>
    <div class="sr-only">
      <.link navigate={~p"/admin/users/#{user}/edit"}>Show</.link>
    </div>
    <.link navigate={~p"/admin/users/#{user}/edit"}>Edit</.link>
    </:action> --%>
      <%!-- <:action :let={user}>
    <.link href={~p"/users/#{user}"} method="delete" data-confirm="Are you sure?">
      Delete
    </.link>
    </:action> --%>
    </.table>
    """
  end

  def mount(_params, _session, socket) do
    form = %{
      "users" => Helper.get_all_users_vs_role_id(),
      "roles" => Helper.get_all_roles_as_map()
    }

    {:ok, assign(socket, form: form)}
    # {:ok,
    #  socket |> assign(users: users) |> assign(roles: roles) |> assign(form: form)}
  end

  # def handle_event("inc_temperature", _params, socket) do
  #   {:noreply, update(socket, :temperature, &(&1 + 1))}
  # end

  def handle_event("change_role", params, socket) do
    # IO.inspect(socket.assigns.form)
    IO.inspect(params)
    socket = put_flash(socket, :info, "Role changed!")
    # {:noreply, update(socket, :temperature, &(&1 + 1))}
    {:noreply, socket}
  end
end
