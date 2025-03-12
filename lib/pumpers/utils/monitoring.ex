defmodule Pumpers.Utils.Monitoring do
  @moduledoc false

  # when is_struct(monitor, %Pumpers.Monitor{})
  def test_monitor(monitor) when is_struct(monitor, Pumpers.Monitors.Monitor) do
    # IO.puts(inspect(monitor))
    case Req.get(monitor.url) do
      {:ok, response} ->
        {:ok, response.body}

      {:error, reason} ->
        {:error, Exception.message(reason)}
    end
  end
end
