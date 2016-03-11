defmodule Chattr.RoomChannel do
  use Chattr.Web, :channel

  alias Chattr.Api.V1.User.ChatRoom.Message

  def join("rooms:lobby", message, socket) do
    Process.flag(:trap_exit, true)
    # :timer.send_interval(5000, :ping)
    send(self, {:after_join, message})
    {:ok, socket}
  end

  def join("rooms:" <> room_id, _params, socket) do
    {:ok, assign(socket, :room_id, room_id)}
  end

  def handle_info({:after_join, body}, socket) do
    broadcast! socket, "user:entered", %{user_id: body["user_id"]}
    push socket, "phx_join", %{status: "connected"}
    {:noreply, socket}
  end

  def terminate(_reason, _socket) do
    # Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("new:message", body, socket) do
    IO.inspect body
    changeset = Message.changeset(%Message{}, body)

    case Repo.insert(changeset) do
      {:ok, message} ->
        broadcast! socket, "new:message", %{user_id: body["user_id"], body: body["message"]}
        {:reply, {:ok, %{message: body["message"], user_id: body["user_id"]}}, assign(socket, :user_id, body["user_id"])}
      {:error, changeset} ->
        {:reply, {:error, %{error_message: "Could not post message", message: body["message"], user_id: body["user_id"]}}, assign(socket, :user_id, body["user_id"])}
    end
  end

  # def handle_info(:ping, socket) do
  #   push socket, "new:message", %{user: "SYSTEM", body: "ping"}
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
