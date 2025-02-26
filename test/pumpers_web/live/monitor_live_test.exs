defmodule PumpersWeb.MonitorLiveTest do
  use PumpersWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pumpers.MonitorsFixtures
  import Pumpers.AccountsFixtures

  @create_attrs %{
    result: "some result",
    url: "some url",
    method: :get,
    post_data: "some post_data"
  }
  @update_attrs %{
    result: "some updated result",
    url: "some updated url",
    method: :post,
    post_data: "some updated post_data"
  }
  @invalid_attrs %{result: nil, url: nil, method: :get, post_data: nil}

  defp create_monitor(_context) do
    monitor = monitor_fixture()
    %{monitor: monitor}
  end

  defp setup_admin_access(context) do
    conn = context.conn
    password = "123456789abcd"
    user = user_fixture(%{password: password})

    {:ok, lv, _html} = live(conn, ~p"/users/log_in")

    form =
      form(lv, "#login_form", user: %{email: user.email, password: password, remember_me: true})

    conn = submit_form(form, conn)

    assert redirected_to(conn) == ~p"/"
    [conn: conn]
  end

  describe "Index" do
    setup [:create_monitor, :setup_admin_access]

    test "lists all monitors", %{conn: conn, monitor: monitor} do
      {:ok, _index_live, html} = live(conn, ~p"/monitors")

      assert html =~ "Listing Monitors"
      assert html =~ monitor.result
    end

    test "saves new monitor", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/monitors")

      assert index_live |> element("a", "New Monitor") |> render_click() =~
               "New Monitor"

      assert_patch(index_live, ~p"/monitors/new")

      assert index_live
             |> form("#monitor-form", monitor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#monitor-form", monitor: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/monitors")

      html = render(index_live)
      assert html =~ "Monitor created successfully"
      assert html =~ "some result"
    end

    test "updates monitor in listing", %{conn: conn, monitor: monitor} do
      {:ok, index_live, _html} = live(conn, ~p"/monitors")

      assert index_live |> element("#monitors-#{monitor.id} a", "Edit") |> render_click() =~
               "Edit Monitor"

      assert_patch(index_live, ~p"/monitors/#{monitor}/edit")

      assert index_live
             |> form("#monitor-form", monitor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#monitor-form", monitor: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/monitors")

      html = render(index_live)
      assert html =~ "Monitor updated successfully"
      assert html =~ "some updated result"
    end

    test "deletes monitor in listing", %{conn: conn, monitor: monitor} do
      {:ok, index_live, _html} = live(conn, ~p"/monitors")

      assert index_live |> element("#monitors-#{monitor.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#monitors-#{monitor.id}")
    end
  end

  describe "Show" do
    setup [:create_monitor, :setup_admin_access]

    test "displays monitor", %{conn: conn, monitor: monitor} do
      {:ok, _show_live, html} = live(conn, ~p"/monitors/#{monitor}")

      assert html =~ "Show Monitor"
      assert html =~ monitor.result
    end

    test "updates monitor within modal", %{conn: conn, monitor: monitor} do
      {:ok, show_live, _html} = live(conn, ~p"/monitors/#{monitor}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Monitor"

      assert_patch(show_live, ~p"/monitors/#{monitor}/edit")

      assert show_live
             |> form("#monitor-form", monitor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#monitor-form", monitor: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/monitors/#{monitor}")

      html = render(show_live)
      assert html =~ "Monitor updated successfully"
      assert html =~ "some updated result"
    end
  end
end
