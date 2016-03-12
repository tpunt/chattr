defmodule Chattr.Api.V1.User.ChatRoomController do
  use Chattr.Web, :controller

  alias Chattr.Api.V1.User.ChatRoom
  alias Chattr.Api.V1.User.ChatRoom.Host

  plug :scrub_params, "chat_room" when action in [:create, :update]

  def index(conn, %{"user_id" => user_id}) do
    chat_rooms = ChatRoom.fetch_user_chat_rooms(user_id)
    render(conn, "index.json", chat_rooms: chat_rooms)
  end

  def create(conn, %{"chat_room" => chat_room_params, "user_id" => user_id, "hosts" => hosts}) do
    chat_room = ChatRoom.changeset(%ChatRoom{}, Map.put(chat_room_params, "user_id", user_id))
    hosts = Enum.map(hosts, &Host.changeset(%Host{}, &1))

    if chat_room.valid? && Enum.all? hosts, & &1.valid? do
      {:ok, conn} = Repo.transaction fn ->
        chat_room = Repo.insert!(chat_room)
        Enum.map(hosts, fn (host) ->
          host = Ecto.Changeset.change(host, chat_room_id: chat_room.id)
          Repo.insert!(host)
        end)

        chat_room = ChatRoom.fetch_user_chat_room(user_id, chat_room.id)

        conn
        |> put_status(:created)
        # |> put_resp_header("location", chat_room_path(conn, :show, chat_room))
        |> render("show.json", chat_room: chat_room)
      end

      conn
    else
      conn
      |> put_status(:unprocessable_entity)
      # |> render(Chattr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def create(conn, %{"chat_room" => chat_room_params, "user_id" => user_id}) do
    changeset = ChatRoom.changeset(%ChatRoom{}, Map.put(chat_room_params, "user_id", user_id))

    case Repo.insert(changeset) do
      {:ok, chat_room} ->
        chat_room = ChatRoom.fetch_user_chat_room(user_id, chat_room.id)

        conn
        |> put_status(:created)
        # |> put_resp_header("location", chat_room_path(conn, :show, chat_room))
        |> render("show.json", chat_room: chat_room)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Chattr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => chat_room_id}) do
    chat_room = ChatRoom.fetch_user_chat_room(user_id, chat_room_id)

    render(conn, "show.json", chat_room: chat_room)
  end

  def update(conn, %{"user_id" => user_id, "id" => id, "chat_room" => chat_room_params}) do
    chat_room = Repo.get!(ChatRoom, id)
    changeset = ChatRoom.changeset(chat_room, Map.put(chat_room_params, "user_id", user_id))

    case Repo.update(changeset) do
      {:ok, chat_room} ->
        render(conn, "show.json", chat_room: chat_room)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Chattr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    chat_room = Repo.get!(ChatRoom, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(chat_room)

    send_resp(conn, :no_content, "")
  end
end
