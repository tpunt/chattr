defmodule Chattr.Api.V1.User.ChatRoomView do
  use Chattr.Web, :view

  def render("index.json", %{chat_rooms: chat_rooms}) do
    %{data: render_many(chat_rooms, Chattr.Api.V1.User.ChatRoomView, "chat_room.json")}
  end

  def render("show.json", %{chat_room: chat_room}) do
    %{data: render_one(chat_room, Chattr.Api.V1.User.ChatRoomView, "chat_room.json")}
  end

  def render("chat_room.json", %{chat_room: chat_room}) do
    %{id: chat_room.id,
      name: chat_room.name,
      user_id: chat_room.user_id}
  end
end
