defmodule Chattr.Api.V1.User.ChatRoom.Host do
  use Chattr.Web, :model

  alias Chattr.Api.V1.User
  alias Chattr.Api.V1.User.ChatRoom
  alias Chattr.Api.V1.User.ChatRoom.Host

  schema "hosts" do
    field :uri, :string
    field :bg_colour, :string
    field :text_colour, :string
    belongs_to :chatroom, ChatRoom

    timestamps
  end

  @required_fields ~w(uri bg_colour text_colour chatroom_id)
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

  def fetch_chatroom_hosts(user_id, chatroom_id) do
    user_query = from u in User,
      where: u.id == ^user_id

    Repo.one! user_query

    # chatroom_query = from cr in ChatRoom,
    #   join: u in user_query, on: u.id == cr.user_id,
    #   where: cr.id == ^chatroom_id

    chatroom_query = from u in user_query,
      join: cr in ChatRoom, on: u.id == cr.user_id,
      where: cr.id == ^chatroom_id

    Repo.one! chatroom_query

    # Repo.all from cr in chatroom_query,
    #   join: h in Host, on: cr.id == h.chatroom_id,
    #   select: h

    Repo.all from u in User,
      join: cr in ChatRoom, on: u.id == cr.user_id,
      join: h in Host, on: cr.id == h.chatroom_id,
      where: u.id == ^user_id and cr.id == ^chatroom_id,
      select: h

      # SELECT h2."id", h2."uri", h2."bg_colour", h2."text_colour", h2."chatroom_id", h2."inserted_at", h2."updated_at" FROM "users" AS u0 INNER JOIN "chatrooms" AS c1 ON u0."id" = c1."user_id" INNER JOIN "hosts" AS h2 ON c1."id" = h2."chatroom_id" WHERE (((u0."id" = 1) AND (c1."id" = 30)) AND (h2."id" = 4))
      # SELECT h2."id", h2."uri", h2."bg_colour", h2."text_colour", h2."chatroom_id", h2."inserted_at", h2."updated_at" FROM "users" AS u0 INNER JOIN "chatrooms" AS c1 ON u0."id" = c1."user_id" INNER JOIN "hosts" AS h2 ON u0."id" = h2."chatroom_id" WHERE (u0."id" = 1) AND (c1."id" = 30)
  end

  def fetch_chatroom_host(user_id, chatroom_id, host_id) do
    Repo.one! from u in User,
      join: cr in ChatRoom, on: u.id == cr.user_id,
      join: h in Host, on: cr.id == h.chatroom_id,
      where: u.id == ^user_id and cr.id == ^chatroom_id and h.id == ^host_id,
      select: h
  end
end
