defmodule Chattr.Api.V1.User do
  use Chattr.Web, :model

  schema "users" do
    field :username, :string
    field :password, :string
    has_many :chat_rooms, Chattr.Api.V1.User.ChatRoom

    timestamps
  end

  @required_fields ~w(username password)
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
