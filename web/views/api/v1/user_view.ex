defmodule Chattr.Api.V1.UserView do
  use Chattr.Web, :view

  def render("index.json", %{users: users}) do
    %{users: render_many(users, Chattr.Api.V1.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, Chattr.Api.V1.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email,
      authenticator: user.authenticator,
      user_id: user.user_id}
  end
end
