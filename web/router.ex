defmodule Chattr.Router do
  use Chattr.Web, :router

  pipeline :api do
    plug Corsica
    plug :accepts, ["json"]
  end

  scope "/api", Chattr.Api do
    pipe_through :api

    scope "/v1", V1 do
      resources "/users/:user_id/chatrooms/:chatroom_id/hosts", User.ChatRoom.HostController, except: [:new, :edit]
      resources "/users/:user_id/chatrooms", User.ChatRoomController, except: [:new, :edit]
      resources "/users", UserController, except: [:new, :edit]
    #   scope "/users/:user_id", User do
    #     scope "/chatrooms/:chatroom_id", ChatRoom do
    #       resources "/hosts", HostController, except: [:new, :edit]
    #     end
    #     resources "/chatrooms", ChatRoomController, except: [:new, :edit]
    #   end
    #   resources "/users", UserController, except: [:new, :edit]
    end
  end
end
