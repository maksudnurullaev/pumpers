defmodule PumpersWeb.MonitorLive.FormComponent do
  use PumpersWeb, :live_component

  alias Pumpers.Monitors

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage monitor records in your database.</:subtitle>
      </.header>
      <.simple_form
        for={@form}
        id="monitor-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:url]} type="url" label="Url" />
        <.input
          field={@form[:method]}
          type="select"
          label="Method"
          options={Ecto.Enum.values(Pumpers.Monitors.Monitor, :method)}
        />
        <.input field={@form[:post_data]} type="textarea" label="Post data" />
        <.input field={@form[:result]} type="textarea" label="Result" readonly />
        <:actions>
          <.button phx-disable-with="Saving...">Save Monitor</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{monitor: monitor} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Monitors.change_monitor(monitor))
     end)}
  end

  @impl true
  def handle_event("validate", %{"monitor" => monitor_params}, socket) do
    changeset = Monitors.change_monitor(socket.assigns.monitor, monitor_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"monitor" => monitor_params}, socket) do
    save_monitor(socket, socket.assigns.action, monitor_params)
  end

  defp save_monitor(socket, :edit, monitor_params) do
    case Monitors.update_monitor(socket.assigns.monitor, monitor_params) do
      {:ok, monitor} ->
        notify_parent({:saved, monitor})

        {:noreply,
         socket
         |> put_flash(:info, "Monitor updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_monitor(socket, :new, monitor_params) do
    case Monitors.create_monitor(monitor_params) do
      {:ok, monitor} ->
        notify_parent({:saved, monitor})

        {:noreply,
         socket
         |> put_flash(:info, "Monitor created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
