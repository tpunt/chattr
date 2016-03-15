defmodule Chattr.RoomChannel do
  use Chattr.Web, :channel

  alias Chattr.Api.V1.Message
  alias Chattr.Api.V1.User

  def join("rooms:lobby", message, socket) do
    Process.flag(:trap_exit, true)

    send(self, {:after_join, message})
    {:ok, assign(socket, :room_id, 0)}
  end

  def join("rooms:" <> room_id, message, socket) do
    send(self, {:after_join, message})
    {:ok, assign(socket, :room_id, room_id)}
  end

  def handle_info({:after_join, body}, socket) do
    user = Repo.get!(User, body["user_id"]) # should be oauth token?

    data = %{user: %{id: user.id, username: user.username}}

    broadcast! socket, "user:joined", data
    push socket, "phx_join", %{status: "connected"}
    {:noreply, socket}
  end

  def terminate(_reason, _socket) do
    # Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("message:new", body, socket) do
    changeset = Message.changeset(%Message{}, body)

    case Repo.insert(changeset) do
      {:ok, message} ->
        data = %{user_id: message.user_id, message: message.message, message_id: message.id, inserted_at: message.inserted_at, updated_at: message.updated_at}
        broadcast! socket, "message:new", data
        {:reply, {:ok, data}, assign(socket, :user_id, body["user_id"])}
      {:error, changeset} ->
        {:reply, {:error, %{error_message: "Could not create message", message: body["message"], user_id: body["user_id"]}}, assign(socket, :user_id, body["user_id"])}
    end
  end

  def handle_in("message:edit", body, socket) do
    message = Repo.get!(Message, body["id"])
    changeset = Message.changeset(message, body)

    case Repo.update(changeset) do
      {:ok, message} ->
        data = %{message: message.message, message_id: message.id, inserted_at: message.inserted_at, updated_at: message.updated_at}
        broadcast! socket, "message:edit", data
        {:reply, {:ok, data}, assign(socket, :user_id, message.user_id)}
      {:error, changeset} ->
        {:reply, {:error, %{error_message: "Could not edit message"}}, assign(socket, :user_id, message.user_id)}
    end
  end

  def handle_in("message:delete", body, socket) do
    message = Repo.get!(Message, body["id"])

    case Repo.delete(message) do
      {:ok, message} ->
        data = %{message_id: message.id}
        broadcast! socket, "message:delete", data
        {:reply, {:ok, data}, assign(socket, :user_id, message.user_id)}
      {:error, changeset} ->
        {:reply, {:error, %{error_message: "Could not delete message"}}, assign(socket, :user_id, message.user_id)}
    end
  end

  # def handle_info(:ping, socket) do
  #   push socket, "message:new", %{user: "SYSTEM", body: "ping"}
  #   {:noreply, socket}
  # end

  # def handle_in("new_message", %{"body" => body}, socket) do
  #   IO.inspect body
  #   broadcast! socket, "new_message", %{body: body}
  #   {:noreply, socket}
  # end

  # def handle_out("new_message", payload, socket) do
  #   IO.inspect payload
  #   push socket, "new_message", payload
  #   {:noreply, socket}
  # end
end
