defmodule Pumpers.Utils.Monitoring do
  alias Pumpers.Monitors.Monitor
  alias Pumpers.Repo

  @moduledoc false

  # when is_struct(monitor, %Pumpers.Monitor{})
  def test_monitor(monitor) when is_struct(monitor, Pumpers.Monitors.Monitor) do
    case get_response(monitor) do
      {:ok, status_code, response_body} ->
        monitor_cs =
          Monitor.changeset(monitor, %{
            status_code: status_code,
            response: "#{inspect(response_body)}"
          })

        Repo.update(monitor_cs)

      {:error, message} ->
        monitor_cs = Monitor.changeset(monitor, %{status_code: 0, response: message})
        IO.puts("XXX_CS_2: Monitor: #{inspect(monitor_cs)}")
        Repo.update(monitor_cs)
    end
  end

  defp get_response(monitor) do
    case Req.get(monitor.url) do
      {:ok, response} ->
        {:ok, response.status, response.body}

      {:error, reason} ->
        {:error, Exception.message(reason)}
    end
  end
end
