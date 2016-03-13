defmodule Chattr.Api.V1.MessageTest do
  use Chattr.ModelCase

  alias Chattr.Api.V1.Message

  @valid_attrs %{latitude: "120.5", location: "some content", longitude: "120.5", message: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    refute changeset.valid?
  end
end
