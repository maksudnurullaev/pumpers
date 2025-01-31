defmodule Pumpers.Accounts.Helper do
  alias Pumpers.Accounts.Role

  @doc """
  Some helper functions for the Accounts context.
  """
  @registered_users_roles_name "Registered Users"

  def get_registered_users_role(field_name \\ nil) do
    require Ecto.Query

    registered_role =
      Role
      |> Pumpers.Repo.get_by(name: @registered_users_roles_name)

    if registered_role do
      if(field_name) do
        Map.get(registered_role, field_name)
      else
        registered_role
      end
    else
      raise "Role '#{@registered_users_roles_name}' not found"
    end
  end
end
