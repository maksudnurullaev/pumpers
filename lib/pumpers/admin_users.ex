defmodule Pumpers.AdminUsers do
  @moduledoc """
  The AdminUsers context.
  """
  import Ecto.Query, warn: false
  alias Pumpers.Repo

  # alias Pumpers.AdminUsers.User
  alias Pumpers.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    query =
      from u in User,
        join: r in assoc(u, :role),
        select: %{id: u.id, email: u.email, role: r.name, role_id: r.id}

    Repo.all(query)
    # Repo.all(User) |> Repo.preload(:role)
  end

  @doc """
  Use role has admin
  def changeset_role(user, params \\ %{}) do
    user
    |> cast(params, [:id, :role_id])

    # |> Repo.preload(:role)
    # |> cast_assoc(:role, with: &Pumpers.Accounts.Role.changeset/2)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  # # @doc """
  # # Creates a user.

  # ## Examples

  #     iex> create_user(%{field: value})
  #     {:ok, %User{}}

  #     iex> create_user(%{field: bad_value})
  #     {:error, %Ecto.Changeset{}}

  # """
  # # def create_user(attrs \\ %{}) do
  # #   %User{}
  # #   |> User.changeset(attrs)
  # #   |> Repo.insert()
  # # end

  # @doc """
  # Updates a user.

  # ## Examples

  #     iex> update_user(user, %{field: new_value})
  #     {:ok, %User{}}

  #     iex> update_user(user, %{field: bad_value})
  #     {:error, %Ecto.Changeset{}}

  # """
  # # def update_user(%User{} = user, attrs) do
  # #   user
  # #   |> User.changeset(attrs)
  # #   |> Repo.update()
  # # end

  # @doc """
  # Deletes a user.

  # ## Examples

  #     iex> delete_user(user)
  #     {:ok, %User{}}

  #     iex> delete_user(user)
  #     {:error, %Ecto.Changeset{}}

  # """
  # # def delete_user(%User{} = user) do
  # #   Repo.delete(user)
  # # end

  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking user changes.

  # ## Examples

  #     iex> change_user(user)
  #     %Ecto.Changeset{data: %User{}}

  # """
  # # def change_user(%User{} = user, attrs \\ %{}) do
  # #   User.changeset(user, attrs)
  # # end
end
