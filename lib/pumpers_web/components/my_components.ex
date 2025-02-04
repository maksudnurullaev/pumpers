defmodule PumpersWeb.MyComponents do
  use Phoenix.Component
  def greet(assigns) do
    ~H"""
    <div>Hello, {@name}!</div>
    """
  end
end
