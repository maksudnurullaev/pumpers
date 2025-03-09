defmodule PumpersWeb.Components.MyComponents do
  use Phoenix.Component

  @doc """
  Renders a small button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button_small(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "phx-submit-loading:opacity-75 rounded-full bg-blue-400 hover:bg-blue-300 py-0 px-2",
        "text-sm font-semibold leading-6 text-white active:text-white/80",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  # Just for testing...
  slot :column, doc: "Columns with column labels" do
    attr :label, :string, required: true, doc: "Column label"
  end

  attr :rows, :list, default: []

  def ttable(assigns) do
    ~H"""
    <table>
      <tr>
        <th :for={col <- @column}>{col.label}</th>
      </tr>
      <tr :for={row <- @rows}>
        <td :for={col <- @column}>{render_slot(col, row)}</td>
      </tr>
    </table>
    """
  end

  slot :inner_block, required: true

  attr :entries, :list, default: []

  def unordered_list(assigns) do
    ~H"""
    <ul>
      <li :for={entry <- @entries}>{render_slot(@inner_block, entry)}</li>
    </ul>
    """
  end
end
