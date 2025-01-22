defmodule PumpersWeb.PumpersHTML do
  use PumpersWeb, :html

  embed_templates "pumpers_html/*"

  attr :messenger, :string, required: true
  def greet(assigns) do
    ~H"""
    <h2>Hello World, from {@messenger}!</h2>
    """
  end
end
