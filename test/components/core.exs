import Phoenix.LiveViewTest

defmodule MyComponents do
  alias PumpersWeb.MyComponents
  alias PumpersWeb.CoreComponents
  use ExUnit.Case

  test "greets" do
    assert render_component(&MyComponents.greet/1, name: "Mary") ==
             "<div>Hello, Mary!</div>"
  end

  # test "flash" do
  #   assert render_component(&CoreComponents.flash/1, flash: %{"info" => "Help"}, kind: :info) ==
  #            "<div>Hello, Mary!</div>"
  # end

end
