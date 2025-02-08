defmodule PumpersWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use PumpersWeb, :controller` and
  `use PumpersWeb, :live_view`.
  """
  import Pumpers.Accounts.Helper
  alias Pumpers.Accounts.User
  use PumpersWeb, :html

  @roles ~w(admin powered user)a

  embed_templates "layouts/*"

  # when is_atom(role) and role in [:admin, :powered, :user] and %User{} == user
  def is_user?(role, user = %User{:id => _id}) when is_atom(role) and role in @roles do
    case role do
      :admin ->
        is_administrator?(user)

      :powered ->
        is_administrator?(user) || is_powered_user?(user)

      # default registred user
      :user ->
        true
        # is_administrator?(user) || is_powered_user?(user) ||
        #   is_registered_user?(user)
    end
  end

  def is_user?(_role, _user) do
    false
  end
end
