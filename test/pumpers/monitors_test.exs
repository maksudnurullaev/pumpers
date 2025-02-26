defmodule Pumpers.MonitorsTest do
  use Pumpers.DataCase

  alias Pumpers.Monitors

  describe "monitors" do
    alias Pumpers.Monitors.Monitor

    import Pumpers.MonitorsFixtures

    @invalid_attrs %{result: nil, url: nil, method: nil, post_data: nil}

    test "list_monitors/0 returns all monitors" do
      monitor = monitor_fixture()
      assert Monitors.list_monitors() == [monitor]
    end

    test "get_monitor!/1 returns the monitor with given id" do
      monitor = monitor_fixture()
      assert Monitors.get_monitor!(monitor.id) == monitor
    end

    test "create_monitor/1 with valid data creates a monitor" do
      valid_attrs = %{result: "some result", url: "some url", method: :get, post_data: "some post_data"}

      assert {:ok, %Monitor{} = monitor} = Monitors.create_monitor(valid_attrs)
      assert monitor.result == "some result"
      assert monitor.url == "some url"
      assert monitor.method == :get
      assert monitor.post_data == "some post_data"
    end

    test "create_monitor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monitors.create_monitor(@invalid_attrs)
    end

    test "update_monitor/2 with valid data updates the monitor" do
      monitor = monitor_fixture()
      update_attrs = %{result: "some updated result", url: "some updated url", method: :post, post_data: "some updated post_data"}

      assert {:ok, %Monitor{} = monitor} = Monitors.update_monitor(monitor, update_attrs)
      assert monitor.result == "some updated result"
      assert monitor.url == "some updated url"
      assert monitor.method == :post
      assert monitor.post_data == "some updated post_data"
    end

    test "update_monitor/2 with invalid data returns error changeset" do
      monitor = monitor_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitors.update_monitor(monitor, @invalid_attrs)
      assert monitor == Monitors.get_monitor!(monitor.id)
    end

    test "delete_monitor/1 deletes the monitor" do
      monitor = monitor_fixture()
      assert {:ok, %Monitor{}} = Monitors.delete_monitor(monitor)
      assert_raise Ecto.NoResultsError, fn -> Monitors.get_monitor!(monitor.id) end
    end

    test "change_monitor/1 returns a monitor changeset" do
      monitor = monitor_fixture()
      assert %Ecto.Changeset{} = Monitors.change_monitor(monitor)
    end
  end
end
