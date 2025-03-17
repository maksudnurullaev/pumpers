defmodule PumpersWeb.MonitorLiveTest do
  alias Pumpers.MonitorsFixtures
  use PumpersWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pumpers.MonitorsFixtures
  import Pumpers.AccountsFixtures

  @create_attrs %{
    url: MonitorsFixtures.valid_url(),
    method: :get
  }

  @update_attrs %{
    url: MonitorsFixtures.valid_url(),
    method: :get
  }

  @update_method2post %{
    method: :post
  }

  @update_post_valid_data %{
    url: MonitorsFixtures.valid_url(),
    method: :post,
    post_data: ~s({"some": "post_data"})
  }

  @invalid_attrs %{url: nil, method: :get}

  @invalid_attrs4post %{url: nil, method: :post}

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
      assert html =~ monitor.url
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
      assert html =~ MonitorsFixtures.valid_url()
    end

    test "updates monitor in listing", %{conn: conn, monitor: monitor} do
      {:ok, index_live, _html} = live(conn, ~p"/monitors")

      assert index_live |> element("#monitors-#{monitor.id} a", "Edit") |> has_element?()

      assert index_live |> element("#monitors-#{monitor.id} a", "Edit") |> render_click() =~
               "Edit Monitor"

      assert_patch(index_live, ~p"/monitors/#{monitor}/edit")

      assert index_live
             |> form("#monitor-form", monitor: @invalid_attrs4post)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#monitor-form", monitor: @update_method2post)
             # post_data  required
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#monitor-form", monitor: @update_post_valid_data)
             |> render_submit()

      assert_patch(index_live, ~p"/monitors")

      html = render(index_live)
      assert html =~ "Monitor updated successfully"
      assert html =~ MonitorsFixtures.valid_url()
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
      {:ok, _show_live, html} = live(conn, ~p"/monitors/#{monitor}/show")

      assert html =~ "Show Monitor"
      assert html =~ monitor.url
    end

    test "updates monitor within modal", %{conn: conn, monitor: monitor} do
      {:ok, show_live, _html} = live(conn, ~p"/monitors/#{monitor}/show")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Monitor"

      assert_patch(show_live, ~p"/monitors/#{monitor}/show/edit")

      assert show_live
             |> form("#monitor-form", monitor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#monitor-form", monitor: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/monitors/#{monitor}/show")

      html = render(show_live)
      assert html =~ "Monitor updated successfully"
      assert html =~ MonitorsFixtures.valid_url()
    end
  end
end
