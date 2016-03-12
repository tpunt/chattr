defmodule Chattr.Api.V1.User.ChatRoom.HostView do
  use Chattr.Web, :view

  def render("index.json", %{hosts: hosts}) do
    %{hosts: render_many(hosts, Chattr.Api.V1.User.ChatRoom.HostView, "host.json")}
  end

  def render("show.json", %{host: host}) do
    %{host: render_one(host, Chattr.Api.V1.User.ChatRoom.HostView, "host.json")}
  end

  def render("host.json", %{host: host}) do
    %{id: host.id,
      uri: host.uri,
      bg_colour: host.bg_colour,
      text_colour: host.text_colour,
      chat_room_id: host.chat_room_id}
  end
end
