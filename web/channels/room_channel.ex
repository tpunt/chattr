defmodule Chattr.RoomChannel do
  use Chattr.Web, :channel

  def join("rooms:lobby", message, socket) do
    Process.flag(:trap_exit, true)
    # :timer.send_interval(5000, :ping)
    send(self, {:after_join, message})
    {:ok, socket}
  end

  def join("rooms:" <> room_id, _params, socket) do
    {:ok, assign(socket, :room_id, room_id)}
  end
  def join(join, message, socket) do
    IO.puts "Debug:"
    IO.inspect join
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: msg["user"]}
    push socket, "phx_join", %{status: "connected"}
    {:noreply, socket}
  end

  def handle_info(:ping, socket) do
    push socket, "new:msg", %{user: "SYSTEM", body: "ping"}
    {:noreply, socket}
  end

  def terminate(_reason, _socket) do
    # Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("new:msg", body, socket) do
    broadcast! socket, "new:msg", %{user: body["user"], body: body["msg"]}
    {:reply, {:ok, %{msg: body["msg"], user: body["user"]}}, assign(socket, :user, body["user"])}
  end

  # def handle_in("new_msg", %{"body" => body}, socket) do
  #   IO.inspect body
  #   broadcast! socket, "new_msg", %{body: body}
  #   {:noreply, socket}
  # end

  # def handle_out("new_msg", payload, socket) do
  #   IO.inspect payload
  #   push socket, "new_msg", payload
  #   {:noreply, socket}
  # end
end
