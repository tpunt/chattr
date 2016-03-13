defmodule Chattr.Api.V1.MessageController do
  use Chattr.Web, :controller

  alias Chattr.Api.V1.Message

  plug :scrub_params, "message" when action in [:create, :update]

  def index(conn, %{"user_id" => user_id, "chat_room_id" => chat_room_id}) do
    index_render(conn, Message.fetch_user_chat_room_messages(user_id, chat_room_id))
  end

  def index(conn, %{"user_id" => user_id}) do
    index_render(conn, Message.fetch_user_messages(user_id))
  end

  def index(conn, %{"chat_room_id" => chat_room_id}) do
    index_render(conn, Message.fetch_chat_room_messages(chat_room_id))
  end

  defp index_render(conn, messages), do: render(conn, "index.json", messages: messages)

  def create(conn, %{"message" => message_params, "chat_room_id" => chat_room_id, "user_id" => user_id}) do
    message_params = Map.put(message_params, "chat_room_id", chat_room_id)
    message_params = Map.put(message_params, "user_id", user_id)
    changeset = Message.changeset(%Message{}, message_params)

    case Repo.insert(changeset) do
      {:ok, message} ->
        conn
        |> put_status(:created)
        # |> put_resp_header("location", message_path(conn, :show, message))
        |> render("show.json", message: message)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Chattr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => message_id}) do
    message = Message.fetch_message(message_id)
    render(conn, "show.json", message: message)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Repo.get!(Message, id)
    changeset = Message.changeset(message, message_params)

    case Repo.update(changeset) do
      {:ok, message} ->
        render(conn, "show.json", message: message)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Chattr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(message)

    send_resp(conn, :no_content, "")
  end
end
