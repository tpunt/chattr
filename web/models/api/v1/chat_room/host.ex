defmodule Chattr.Api.V1.ChatRoom.Host do
  use Chattr.Web, :model

  alias Chattr.Api.V1.User
  alias Chattr.Api.V1.ChatRoom
  alias Chattr.Api.V1.ChatRoom.Host

  schema "hosts" do
    field :uri, :string
    field :bg_colour, :string
    field :text_colour, :string
    belongs_to :chat_room, ChatRoom

    timestamps
  end

  @required_fields ~w(uri bg_colour text_colour)
  @optional_fields ~w(chat_room_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def fetch_chat_room_hosts(chat_room_id) do
    # chat_room_query = from cr in ChatRoom,
    #   join: u in user_query, on: u.id == cr.user_id,
    #   where: cr.id == ^chat_room_id

    chat_room_query = from cr in ChatRoom,
      where: cr.id == ^chat_room_id

    Repo.one! chat_room_query

    # Repo.all from cr in chat_room_query,
    #   join: h in Host, on: cr.id == h.chat_room_id,
    #   select: h

    Repo.all from cr in ChatRoom,
      join: h in Host, on: cr.id == h.chat_room_id,
      where: cr.id == ^chat_room_id,
      select: h

      # SELECT h2."id", h2."uri", h2."bg_colour", h2."text_colour", h2."chat_room_id", h2."inserted_at", h2."updated_at" FROM "users" AS u0 INNER JOIN "chat_rooms" AS c1 ON u0."id" = c1."user_id" INNER JOIN "hosts" AS h2 ON c1."id" = h2."chat_room_id" WHERE (((u0."id" = 1) AND (c1."id" = 30)) AND (h2."id" = 4))
      # SELECT h2."id", h2."uri", h2."bg_colour", h2."text_colour", h2."chat_room_id", h2."inserted_at", h2."updated_at" FROM "users" AS u0 INNER JOIN "chat_rooms" AS c1 ON u0."id" = c1."user_id" INNER JOIN "hosts" AS h2 ON u0."id" = h2."chat_room_id" WHERE (u0."id" = 1) AND (c1."id" = 30)
  end

  def fetch_chat_room_host(chat_room_id, host_id) do
    Repo.one! from cr in ChatRoom,
      join: h in Host, on: cr.id == h.chat_room_id,
      where: cr.id == ^chat_room_id and h.id == ^host_id,
      select: h
  end
end
