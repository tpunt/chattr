defmodule Chattr.Api.V1.ChatRoom.HostView do
  use Chattr.Web, :view

  alias Chattr.Api.V1.ChatRoom.HostView

  def render("index.json", %{hosts: hosts}) do
    %{hosts: render_many(hosts, HostView, "host.json")}
  end

  def render("show.json", %{host: host}) do
    %{host: render_one(host, HostView, "host.json")}
  end

  def render("host.json", %{host: host}) do
    IO.inspect host
    %{id: host.id,
      uri: host.uri,
      bg_colour: host.bg_colour,
      text_colour: host.text_colour,
      chat_room_id: host.chat_room_id}
  end
end
