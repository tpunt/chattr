defmodule Chattr.Api.V1.UserView do
  use Chattr.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Chattr.Api.V1.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Chattr.Api.V1.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      password: user.password}
  end
end
