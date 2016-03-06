defmodule Chattr.Api.V1.User.ChatRoom do
  use Chattr.Web, :model

  alias Chattr.Api.V1.User
  alias Chattr.Api.V1.User.ChatRoom

  schema "chatrooms" do
    field :name, :string
    belongs_to :user, User

    timestamps
  end

  @required_fields ~w(name user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def fetch_user_chatrooms(user_id) do
    user_query = from u in User,
      where: u.id == ^user_id

    Repo.one! user_query

    Repo.all from u in user_query,
      join: cr in ChatRoom, on: u.id == cr.user_id,
      select: cr
  end

  def fetch_user_chatroom(user_id, chatroom_id) do
    Repo.one! from u in User,
      join: cr in ChatRoom, on: u.id == cr.user_id,
      where: u.id == ^user_id and cr.id == ^chatroom_id,
      select: cr
  end
end
