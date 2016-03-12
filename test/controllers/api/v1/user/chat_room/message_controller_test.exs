defmodule Chattr.Api.V1.User.ChatRoom.MessageControllerTest do
  use Chattr.ConnCase

  alias Chattr.Api.V1.User.ChatRoom.Message
  @valid_attrs %{latitude: "120.5", location: "some content", longitude: "120.5", message: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, message_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = get conn, message_path(conn, :show, message)
    assert json_response(conn, 200)["data"] == %{"id" => message.id,
      "message" => message.message,
      "chat_room_id" => message.chat_room_id,
      "user_id" => message.user_id,
      "longitude" => message.longitude,
      "latitude" => message.latitude,
      "location" => message.location}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, message_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, message_path(conn, :create), message: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, message_path(conn, :create), message: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = put conn, message_path(conn, :update, message), message: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = put conn, message_path(conn, :update, message), message: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = delete conn, message_path(conn, :delete, message)
    assert response(conn, 204)
    refute Repo.get(Message, message.id)
  end
end
