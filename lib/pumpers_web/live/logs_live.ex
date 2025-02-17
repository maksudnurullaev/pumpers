defmodule PumpersWeb.LogsLive do
  # use PumpersWeb.Utils

  use PumpersWeb, :live_view
  alias Pumpers.Accounts.Helper
  alias Pumpers.LogsHelper
  import PumpersWeb.MyComponents

  # alias PumpersWeb.LiveMacro

  def render(assigns) do
    ~H"""
    <%= if @details do %>
      <.header>
        <.button_small phx-click="hide_detail" class="ml-2">
          <span aria-hidden="true">&larr;</span>back
        </.button_small>
        Request headers
      </.header>
      <.table id="details" rows={@details}>
        <:col :let={detail} label="Name">{detail.field}</:col>
        <:col :let={detail} label="Value">
          {detail.value}
        </:col>
      </.table>
    <% else %>
      <.header>
        Logs: <u>{String.to_integer(@toolbar["count"])}</u> records
      </.header>

      <.form for={@toolbar} phx-submit="set_toolbar" phx-value-pages={@toolbar["pages"]}>
        <ul class="flex">
          <li class="mr-6">
            <.input
              id="logs_page_number_id"
              name="page"
              type="select"
              value={@toolbar["page"]}
              options={1..String.to_integer(@toolbar["pages"])}
              phx-change={JS.push("set_page")}
              disabled={@toolbar["pages"] == "1"}
            />
          </li>
          <li class="mr-6">
            <.input
              id="logs_page_size_id"
              name="page_size"
              type="select"
              value={@toolbar["page_size"]}
              options={[25, 50, 100]}
              phx-change={JS.push("set_page_size")}
            />
          </li>
          <li class="mr-6">
            <.input
              value={@toolbar["search_path"]}
              name="search_path"
              type="search"
              placeholder="search path"
            />
          </li>
          <li class="mr-6">
            <.input
              value={@toolbar["search_text"]}
              name="search_text"
              type="search"
              placeholder="search text"
            />
          </li>
          <li class="mr-6">
            <.button data-tooltip-target="tooltip-default" class="mt-2 bg-blue-600 hover:bg-sky-500">
              Search
            </.button>
          </li>
        </ul>
      </.form>

      <.table id="logs" rows={@logs} row_click={&JS.push("get_log_details", value: %{oid: &1.oid})}>
        <:col :let={log} label="#ID">{log.id}</:col>
        <:col :let={log} label="[HOST]:[METHOD]:[PATH]">{log.value}</:col>
      </.table>
    <% end %>
    """
  end

  # def hide_modal(js \\ %JS{}) do
  #   js
  #   |> JS.hide(transition: "fade-out", to: "#modal")
  #   |> JS.hide(transition: "fade-out-scale", to: "#modal-content")
  # end

  defmacro check_access_then(socket, do: block) do
    quote do
      socket = unquote(socket)

      if not Helper.user_is_valid_by_update_at?(socket.assigns[:current_user]) do
        socket = put_flash(socket, :error, "User does not have proper rights!")
        {:noreply, redirect(socket, to: ~p"/")}
      else
        unquote(block)
      end
    end
  end

  def mount(_params, _session, socket) do
    check_access_then(socket) do
      toolbar = %{
        "page" => "1",
        "pages" => "1",
        "page_size" => "25",
        "count" => "0",
        "search_path" => "",
        "search_text" => ""
      }

      {:ok, logs, toolbar} = LogsHelper.get_logs(toolbar)

      form = [
        logs: logs,
        details: nil,
        toolbar: toolbar
      ]

      {:ok, assign(socket, form)}
    end
  end

  # if not Helper.user_is_valid_by_update_at?(socket.assigns[:current_user]) do
  #   socket = put_flash(socket, :error, "User does not have proper rights!")
  #   {:noreply, redirect(socket, to: ~p"/")}
  # else
  # end
  # end

  def handle_event("set_toolbar", params, socket) do
    check_access_then(socket) do
      toolbar = Map.merge(socket.assigns[:toolbar], params)

      if Map.equal?(socket.assigns[:toolbar], toolbar) do
        {:noreply, socket}
      else
        {:ok, logs, toolbar} = LogsHelper.get_logs(toolbar)
        {:noreply, update(socket, :toolbar, &(&1 = toolbar)) |> update(:logs, &(&1 = logs))}
      end
    end
  end

  def handle_event("set_page", params, socket) do
    check_access_then(socket) do
      toolbar = Map.merge(socket.assigns[:toolbar], params)

      {:ok, logs, toolbar} = LogsHelper.get_logs(toolbar)
      {:noreply, update(socket, :toolbar, &(&1 = toolbar)) |> update(:logs, &(&1 = logs))}
    end
  end

  def handle_event("set_page_size", params, socket) do
    check_access_then(socket) do
      toolbar = Map.merge(socket.assigns[:toolbar], params)
      toolbar = Map.put(toolbar, "page", "1")

      {:ok, logs, toolbar} = LogsHelper.get_logs(toolbar)
      {:noreply, update(socket, :toolbar, &(&1 = toolbar)) |> update(:logs, &(&1 = logs))}
    end
  end

  def handle_event("hide_detail", _params, socket) do
    {:noreply, update(socket, :details, &(&1 = nil))}
  end

  def handle_event(
        "get_log_details",
        %{"oid" => oid},
        socket
      ) do
    check_access_then(socket) do
      details = LogsHelper.get_log_details(oid)
      {:noreply, update(socket, :details, &(&1 = details))}
    end
  end
end
