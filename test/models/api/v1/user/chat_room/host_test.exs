defmodule Chattr.Api.V1.User.ChatRoom.HostTest do
  use Chattr.ModelCase

  alias Chattr.Api.V1.User.ChatRoom.Host

  @valid_attrs %{bg_colour: "some content", text_colour: "some content", uri: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Host.changeset(%Host{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Host.changeset(%Host{}, @invalid_attrs)
    refute changeset.valid?
  end
end
