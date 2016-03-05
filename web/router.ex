defmodule Chattr.Router do
  use Chattr.Web, :router

  pipeline :api do
    plug Corsica
    plug :accepts, ["json"]
  end

  scope "/api", Chattr.Api do
    pipe_through :api

    scope "/v1", V1 do
      resources "/users/:id/chatrooms", User.ChatRoomController, except: [:new, :edit]
      resources "/users", UserController, except: [:new, :edit]
    end
  end
end
