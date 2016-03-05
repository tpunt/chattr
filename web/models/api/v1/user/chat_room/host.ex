defmodule Chattr.Api.V1.User.ChatRoom.Host do
  use Chattr.Web, :model

  schema "hosts" do
    field :uri, :string
    field :bg_colour, :string
    field :text_colour, :string
    belongs_to :chatroom, Chattr.Api.V1.User.ChatRoom

    timestamps
  end

  @required_fields ~w(uri bg_colour text_colour chatroom_id)
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
