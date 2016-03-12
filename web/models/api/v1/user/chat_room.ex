defmodule Chattr.Api.V1.User.ChatRoom do
  use Chattr.Web, :model

  alias Chattr.Api.V1.User
  alias Chattr.Api.V1.User.ChatRoom
  alias Chattr.Api.V1.User.ChatRoom.Host
  alias Chattr.Api.V1.User.ChatRoom.Message

  schema "chat_rooms" do
    field :name, :string
    belongs_to :user, User
    has_many :hosts, Host
    has_many :messages, Message

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

  def fetch_user_chat_rooms(user_id) do
    user_query = from u in User,
      where: u.id == ^user_id

    Repo.one! user_query

    # Repo.all from u in user_query,
    #   join: cr in ChatRoom, on: u.id == cr.user_id,
    #   select: cr

    Repo.all from cr in ChatRoom,
      join: u in User, on: u.id == cr.user_id,
      left_join: h in assoc(cr, :hosts),
      where: u.id == ^user_id,
      preload: [hosts: h],
      select: cr
  end

  def fetch_user_chat_room(user_id, chat_room_id) do
    # Repo.one! from u in User,
    #   join: cr in ChatRoom, on: u.id == cr.user_id,
    #   join: h in assoc(cr, :hosts),
    #   where: u.id == ^user_id and cr.id == ^chat_room_id,
    #   preload: [hosts: h],
    #   select: cr

    Repo.one! from cr in ChatRoom,
      join: u in User, on: u.id == cr.user_id,
      left_join: h in assoc(cr, :hosts),
      where: u.id == ^user_id and cr.id == ^chat_room_id,
      preload: [hosts: h],
      select: cr
  end
end
