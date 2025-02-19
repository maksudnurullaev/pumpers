defmodule PumpersWeb.Components.Monitors do
  use Phoenix.Component
  import PumpersWeb.CoreComponents
  import PumpersWeb.Components.MyComponents
  alias Phoenix.LiveView.JS

  def monitor_list(assigns) do
    ~H"""
    <.header>
      Monitors
      <.button_small phx-click="add_monitor_form">
        add <span aria-hidden="true">&rarr;</span>
      </.button_small>
    </.header>
    """
  end

  def monitor_form(assigns) do
    ~H"""
    <.header>
      Add monitor
      <.button_small phx-click="list_monitors">
        <span aria-hidden="true">&larr;</span> back
      </.button_small>
    </.header>

    <.form for={@monitor} phx-submit="add_monitor">
      <.input
        id="monitor_url"
        name="url"
        type="text"
        label="URL:"
        value={@monitor["url"]}
        errors={@errors["url"]}
        placeholder="http://example.com/test/path"
        phx-blur="validate_url"
      />
      <.input
        id="monitor_method"
        name="method"
        type="select"
        label="Method:"
        value={@monitor["method"]}
        options={["GET", "POST"]}
        phx-change={JS.push("set_method")}
      />
      <%= if @monitor["method"] == "POST" do %>
        <.input
          id="monitor_post_data"
          name="post_data"
          type="textarea"
          label="Post data:"
          value={@monitor["post_data"]}
        />
      <% end %>
      <.input
        id="monitor_result"
        name="result"
        type="textarea"
        label="Expected result:"
        value={@monitor["result"]}
      />
      <div class="mt-2 text-right">
        <.button type="submit" class="bg-blue-700 hover:bg-blue-500">Save</.button>
      </div>
    </.form>
    """
  end
end
