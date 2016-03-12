defmodule Chattr.Router do
  use Chattr.Web, :router

  pipeline :api do
    plug Corsica
    plug :accepts, ["json"]
  end

  scope "/api", Chattr.Api do
    pipe_through :api

    scope "/v1", V1 do
      resources "/users/:user_id/chat_rooms/:chat_room_id/messages", User.ChatRoom.MessageController, except: [:new, :edit]
      resources "/users/:user_id/chat_rooms/:chat_room_id/hosts", User.ChatRoom.HostController, except: [:new, :edit]
      resources "/users/:user_id/chat_rooms", User.ChatRoomController, except: [:new, :edit]
      resources "/users", UserController, except: [:new, :edit]
    #   scope "/users/:user_id", User do
    #     scope "/chat_rooms/:chat_room_id", ChatRoom do
    #       resources "/messages", MessageController, except: [:new, :edit]
    #       resources "/hosts", HostController, except: [:new, :edit]
    #     end
    #     resources "/chat_rooms", ChatRoomController, except: [:new, :edit]
    #   end
    #   resources "/users", UserController, except: [:new, :edit]
    end
  end
end
