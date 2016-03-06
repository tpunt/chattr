defmodule Chattr.Api.V1.User.ChatRoom.Message do
  use Chattr.Web, :model

  schema "messages" do
    field :message, :string
    field :longitude, :decimal
    field :latitude, :decimal
    field :location, :string
    belongs_to :chatroom, Chattr.Chatroom
    belongs_to :user, Chattr.User

    timestamps
  end

  @required_fields ~w(message longitude latitude location)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
