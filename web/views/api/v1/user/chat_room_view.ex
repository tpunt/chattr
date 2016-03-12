defmodule Chattr.Api.V1.User.ChatRoomView do
  use Chattr.Web, :view

  alias Chattr.Api.V1.User.ChatRoom.HostView

  def render("index.json", %{chat_rooms: chat_rooms}) do
    %{chat_rooms: render_many(chat_rooms, Chattr.Api.V1.User.ChatRoomView, "chat_room.json")}
  end

  def render("show.json", %{chat_room: chat_room}) do
    %{chat_room: render_one(chat_room, Chattr.Api.V1.User.ChatRoomView, "chat_room.json")}
  end

  def render("chat_room.json", %{chat_room: chat_room}) do
    %{id: chat_room.id,
      name: chat_room.name,
      user_id: chat_room.user_id}
    |> Map.merge(HostView.render("index.json", hosts: chat_room.hosts))
  end
end
