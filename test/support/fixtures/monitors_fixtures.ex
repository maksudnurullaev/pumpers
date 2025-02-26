defmodule Pumpers.MonitorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pumpers.Monitors` context.
  """

  @doc """
  Generate a monitor.
  """
  def monitor_fixture(attrs \\ %{}) do
    {:ok, monitor} =
      attrs
      |> Enum.into(%{
        method: :get,
        post_data: "some post_data",
        result: "some result",
        url: "some url"
      })
      |> Pumpers.Monitors.create_monitor()

    monitor
  end
end
