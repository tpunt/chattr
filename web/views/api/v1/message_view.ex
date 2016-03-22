defmodule Chattr.Api.V1.MessageView do
  use Chattr.Web, :view

  alias Chattr.Api.V1.MessageView

  def render("index.json", %{messages: messages}) do
    %{messages: render_many(messages, MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{message: render_one(message, MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{id: message.id,
      message: message.message,
      chat_room_id: message.chat_room_id,
      longitude: message.longitude,
      latitude: message.latitude,
      location: message.location,
      user: %{
        id: message.user.user_id,
        name: message.user.name,
        email: message.user.email
      }}
  end
end
