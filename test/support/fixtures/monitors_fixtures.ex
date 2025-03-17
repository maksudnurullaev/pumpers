defmodule Pumpers.MonitorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pumpers.Monitors` context.
  """

  @doc """
  Generate a monitor.
  """

  @valid_url "https://www.some.url/with/path"

  def monitor_fixture(attrs \\ %{}) do
    {:ok, monitor} =
      attrs
      |> Enum.into(%{
        method: :get,
        # post_data: "some post_data",
        # response: "some response",
        url: valid_url()
      })
      |> Pumpers.Monitors.create_monitor()

    monitor
  end

  def valid_url(), do: @valid_url
end
