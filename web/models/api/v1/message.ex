defmodule Chattr.Api.V1.Message do
  use Chattr.Web, :model

  alias Chattr.Api.V1.Message
  alias Chattr.Api.V1.User
  alias Chattr.Api.V1.User.ChatRoom

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

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def fetch_chat_room_messages(chat_room_id) do
    Repo.all from m in Message,
      where: m.chat_room_id == ^chat_room_id,
      select: m
  end

  def fetch_user_messages(user_id) do
    Repo.all from m in Message,
      where: m.user_id == ^user_id,
      select: m
  end

  def fetch_user_chat_room_messages(user_id, chat_room_id) do
    Repo.all from m in Message,
      where: m.user_id == ^user_id and m.chat_room_id == ^chat_room_id,
      select: m
  end

  def fetch_message(message_id) do
    Repo.one! from m in Message,
      where: m.id == ^message_id,
      select: m
  end
end
