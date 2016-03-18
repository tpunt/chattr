defmodule Chattr.Api.V1.User do
  use Chattr.Web, :model

  alias Chattr.Api.V1.GoogleAuth
  alias Chattr.Api.V1.User

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: :true
    field :password_confirmation, :string, virtual: :true
    field :password_hash, :string
    field :authenticator, :string
    field :token, :string, virtual: :true
    field :user_id, :string
    has_many :chat_rooms, Chattr.Api.V1.User.ChatRoom

    timestamps
  end

  @manual_signup_required_fields ~w(name email password password_confirmation)
  @manual_signup_optional_fields ~w()

  @auto_signup_required_fields ~w(authenticator token)
  @auto_signup_optional_fields ~w()

  # @required_fields ~w()
  # @optional_fields ~w(name password_hash password password_confirmation authenticator user_id)
  @minimum_password_length 8

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, %{"authenticator" => "google"} = params) do
    model
    |> cast(params, @auto_signup_required_fields, @auto_signup_optional_fields)
    |> GoogleAuth.changeset
    |> unique_constraint(:email)
  end

  def changeset(model, %{"user" => user_params}) do
    model
    |> cast(user_params, @manual_signup_required_fields, @manual_signup_optional_fields)
    |> put_change(:authenticator, "google") #fetch from params var
    |> validate_length(:password, min: @minimum_password_length)
    |> password_confirmation
    |> unique_constraint(:email)
    |> hash_password
  end

  def get_user_by_user_id(user_id) do
    Repo.one from u in User,
      where: u.user_id == ^user_id,
      select: u
  end

  defp password_confirmation(changeset) do
    if changeset.changes.password === changeset.changes.password_confirmation do
      changeset
    else
      {:error, "Passwords do not match"}
    end
  end

  defp hash_password(changeset) do
    # if password = get_change(changeset, :password) do
      changeset
      # |> put_change(:password_hash, hashpwsalt(password))
    # else
      # changeset
    # end
  end
end
