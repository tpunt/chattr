defmodule Chattr.Api.V1.User.ChatRoom.Message do
  use Chattr.Web, :model

  alias Chattr.Api.V1.User
  alias Chattr.Api.V1.User.ChatRoom
  alias Chattr.Api.V1.User.ChatRoom.Message

  schema "messages" do
    field :message, :string
    field :longitude, :decimal
    field :latitude, :decimal
    field :location, :string
    belongs_to :chat_room, Chattr.Chatroom
    belongs_to :user, Chattr.User

    timestamps
  end

  @required_fields ~w(message chat_room_id user_id)
  @optional_fields ~w(longitude latitude location)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def fetch_chat_room_messages(user_id, chat_room_id) do
    user_query = from u in User,
      where: u.id == ^user_id

    Repo.one! user_query

    # chat_room_query = from cr in ChatRoom,
    #   join: u in user_query, on: u.id == cr.user_id,
    #   where: cr.id == ^chat_room_id

    chat_room_query = from u in user_query,
      join: cr in ChatRoom, on: u.id == cr.user_id,
      where: cr.id == ^chat_room_id

    Repo.one! chat_room_query

    # Repo.all from cr in chat_room_query,
    #   join: m in Message, on: cr.id == m.chat_room_id,
    #   select: m

    Repo.all from u in User,
      join: cr in ChatRoom, on: u.id == cr.user_id,
      join: m in Message, on: cr.id == m.chat_room_id,
      where: u.id == ^user_id and cr.id == ^chat_room_id,
      select: m

      # SELECT h2."id", h2."uri", h2."bg_colour", h2."text_colour", h2."chat_room_id", h2."inserted_at", h2."updated_at" FROM "users" AS u0 INNER JOIN "chat_rooms" AS c1 ON u0."id" = c1."user_id" INNER JOIN "hosts" AS h2 ON c1."id" = h2."chat_room_id" WHERE (((u0."id" = 1) AND (c1."id" = 30)) AND (h2."id" = 4))
      # SELECT h2."id", h2."uri", h2."bg_colour", h2."text_colour", h2."chat_room_id", h2."inserted_at", h2."updated_at" FROM "users" AS u0 INNER JOIN "chat_rooms" AS c1 ON u0."id" = c1."user_id" INNER JOIN "hosts" AS h2 ON u0."id" = h2."chat_room_id" WHERE (u0."id" = 1) AND (c1."id" = 30)
  end

  def fetch_chat_room_message(user_id, chat_room_id, message_id) do
    Repo.one! from u in User,
      join: cr in ChatRoom, on: u.id == cr.user_id,
      join: m in Message, on: cr.id == m.chat_room_id,
      where: u.id == ^user_id and cr.id == ^chat_room_id and m.id == ^message_id,
      select: m
  end
end
