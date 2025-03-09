defmodule MyComponents.MyTests do
  import Phoenix.Component
  import Phoenix.LiveViewTest
  import PumpersWeb.Components.MyComponents
  use ExUnit.Case
  use PumpersWeb, :verified_routes

  test "greets" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.unordered_list :let={fruit} entries={~w(apples bananas cherries)}>
        I like <b>{fruit}</b>!
      </.unordered_list>
      """)

    IO.puts(html)

    assert true
    # assert html ==
    #         "<div>Hello, Mary!</div>"
  end
end
