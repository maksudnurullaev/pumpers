defmodule PumpersWeb.AdminUsersHTML do
  use PumpersWeb, :html

  embed_templates "admin_users_html/*"

  @doc """
  Renders a user form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :roles, :list, required: true

  def user_form(assigns)
end
