defmodule Chattr.Api.V1.User.ChatRoom.MessageView do
  use Chattr.Web, :view

  def render("index.json", %{messages: messages}) do
    %{messages: render_many(messages, Chattr.Api.V1.User.ChatRoom.MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{message: render_one(message, Chattr.Api.V1.User.ChatRoom.MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{id: message.id,
      message: message.message,
      chat_room_id: message.chat_room_id,
      user_id: message.user_id,
      longitude: message.longitude,
      latitude: message.latitude,
      location: message.location}
  end
end
