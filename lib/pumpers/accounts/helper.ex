defmodule Pumpers.Accounts.Helper do
  require Logger
  alias Pumpers.Accounts.{Role, User}
  alias Pumpers.Repo
  import Ecto.Query, warn: false

  @doc """
  Some helper functions for the Accounts context.
  """
  @registered_users_roles_name "Registered Users"
  @powered_users_roles_name "Powered Users"
  @administrators_users_roles_name "Administrators"

  def count_of(schema) do
    schema |> Repo.aggregate(:count)
  end

  def user_is_valid_by_update_at?(%{:id => id, :updated_at => updated_at} = _user) do
    user_updated_at = User |> Repo.get!(id) |> Map.get(:updated_at)
    user_updated_at == updated_at
  end

  def user_is_valid_by_update_at?(_user) do
    Logger.warning("User is not valid!")
    false
  end

  def change_user_role(user_id, user_role_id_new) when is_integer(user_id) do
    user = User |> Repo.get!(user_id)
    user_role_id_old = user.role_id

    if user_role_id_old != user_role_id_new do
      user
      |> Ecto.Changeset.change(role_id: String.to_integer(user_role_id_new))
      |> Repo.update!()
    end
  end

  def get_all_roles_as_map() do
    Pumpers.Accounts.Role |> Pumpers.Repo.all() |> Enum.map(&{&1.name, &1.id})
  end

  def get_all_users_vs_role_id() do
    query =
      from u in User,
        join: r in assoc(u, :role),
        select: %{id: u.id, email: u.email, role: r.name, role_id: r.id}

    Repo.all(query)
  end

  def has_role?(%User{:role_id => role_id}, role_name) do
    Role |> Pumpers.Repo.get(role_id) |> Map.get(:name) == role_name
  end

  def is_administrator?(%User{:role_id => role_id}) do
    has_role?(%User{:role_id => role_id}, @administrators_users_roles_name)
  end

  def is_powered_user?(%User{:role_id => role_id}) do
    has_role?(%User{:role_id => role_id}, @powered_users_roles_name)
  end

  def is_registered_user?(%User{:role_id => role_id}) do
    has_role?(%User{:role_id => role_id}, @registered_users_roles_name)
  end

  def get_roles_map() do
    %{
      @registered_users_roles_name => false,
      @powered_users_roles_name => false,
      @administrators_users_roles_name => true
    }
  end

  def get_all_roles_names() do
    [@administrators_users_roles_name, @powered_users_roles_name, @registered_users_roles_name]
  end

  def get_registered_role_or_field(field_name \\ nil) do
    get_role_or_field(@registered_users_roles_name, field_name)
  end

  def get_powered_role_or_field(field_name \\ nil) do
    get_role_or_field(@powered_users_roles_name, field_name)
  end

  def get_administrators_role_or_field(field_name \\ nil) do
    get_role_or_field(@administrators_users_roles_name, field_name)
  end

  def get_role_or_field(role_name, field_name \\ nil) do
    require Ecto.Query
    # IO.puts("... ROLE: '#{role_name}'")

    role =
      Role
      |> Pumpers.Repo.get_by(name: role_name)

    if role do
      if field_name do
        Map.get(role, field_name)
      else
        role
      end
    else
      raise "Role '#{role_name}' not found"
    end
  end

  @doc """
    First user should be an administrator
  """
  def get_detault_role_for_new_users() do
    if User |> Ecto.Query.first() |> Pumpers.Repo.one() do
      get_registered_role_or_field()
    else
      get_administrators_role_or_field()
    end
  end
end
