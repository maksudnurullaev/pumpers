defmodule PumpersWeb.LogsLive do
  use PumpersWeb, :live_view
  alias Pumpers.Accounts.Helper
  alias Pumpers.LogsHelper

  def render(assigns) do
    ~H"""
    <.header>
      Logs - {@show_modal}
    </.header>

    <.form for={@toolbar} phx-submit="get_details">
      <ul class="flex">
        <li class="mr-6">
          <.input
            id="logs_page_size_id"
            name="page_size"
            type="select"
            value={@toolbar["page_size"]}
            options={[25, 50, 100]}
          />
        </li>
        <li class="mr-6">
          <.input
            value={@toolbar["search_text"]}
            name="my-input"
            type="search"
            placeholder="search text"
          />
        </li>
        <li class="mr-6">
          <.button class="mt-2 bg-indigo-500 hover:bg-indigo-600">
            Search
          </.button>
        </li>
      </ul>
    </.form>
    <.table id="logs" rows={@logs} row_click={&JS.push("get_details", value: %{oid: &1.oid})}>
      <:col :let={log} label="#ID">{log.id}</:col>
      <:col :let={log} label="[HOST]:[METHOD]:[PATH]">{log.value}</:col>
    </.table>

    <%= if @details do %>
      <.modal id="details-modal" show={@show_modal} on_cancel={JS.push("hide_modal")}>
        <.header>
          Details
        </.header>
        <.table id="details" rows={@details}>
          <:col :let={detail} label="Name">{detail.field}</:col>
          <:col :let={detail} label="Value"><textarea readonly>{detail.value}</textarea></:col>
        </.table>
      </.modal>
    <% end %>
    """
  end

  # def hide_modal(js \\ %JS{}) do
  #   js
  #   |> JS.hide(transition: "fade-out", to: "#modal")
  #   |> JS.hide(transition: "fade-out-scale", to: "#modal-content")
  # end

  def mount(_params, _session, socket) do
    logs = LogsHelper.get_log_by_name()

    form = [
      logs: logs,
      details: nil,
      show_modal: false,
      toolbar: %{
        "page_size" => 25,
        "search_text" => ""
      }
    ]

    {:ok, assign(socket, form)}
  end

  def handle_event("hide_modal", _params, socket) do
    # form = %{
    #   "details" => nil,
    #   "show_modal" => false
    # }
    # |> update(:show_modal, &(&1 = false))
    # socket = socket |> update(:details, &(&1 = nil))
    socket = socket |> update(:details, &(&1 = nil)) |> update(:show_modal, &(&1 = false))
    {:noreply, socket}
  end

  def handle_event(
        "get_details",
        %{"oid" => oid},
        socket
      ) do
    current_user = socket.assigns[:current_user]

    if Helper.user_is_valid_by_update_at?(current_user) do
      # socket = put_flash(socket, :info, "get_details")
      # logs = LogsHelper.get_log_by_name()
      # IO.inspect(LogsHelper.get_log_details(oid))

      # form = %{
      #   "logs" => LogsHelper.get_log_by_name(),
      #   "details" => LogsHelper.get_log_details(oid),
      #   "show_modal" => true
      # }

      details = LogsHelper.get_log_details(oid)
      socket = socket |> update(:details, &(&1 = details)) |> update(:show_modal, &(&1 = true))
      {:noreply, socket}
    else
      socket = put_flash(socket, :error, "User does not have proper rights!")
      {:noreply, redirect(socket, to: ~p"/")}
    end
  end
end
