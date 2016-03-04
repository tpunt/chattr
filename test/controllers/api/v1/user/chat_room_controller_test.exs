defmodule Chattr.Api.V1.User.ChatRoomControllerTest do
  use Chattr.ConnCase

  alias Chattr.Api.V1.User.ChatRoom
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, chat_room_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    chat_room = Repo.insert! %ChatRoom{}
    conn = get conn, chat_room_path(conn, :show, chat_room)
    assert json_response(conn, 200)["data"] == %{"id" => chat_room.id,
      "name" => chat_room.name}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, chat_room_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, chat_room_path(conn, :create), chat_room: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ChatRoom, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, chat_room_path(conn, :create), chat_room: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    chat_room = Repo.insert! %ChatRoom{}
    conn = put conn, chat_room_path(conn, :update, chat_room), chat_room: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ChatRoom, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    chat_room = Repo.insert! %ChatRoom{}
    conn = put conn, chat_room_path(conn, :update, chat_room), chat_room: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    chat_room = Repo.insert! %ChatRoom{}
    conn = delete conn, chat_room_path(conn, :delete, chat_room)
    assert response(conn, 204)
    refute Repo.get(ChatRoom, chat_room.id)
  end
end
