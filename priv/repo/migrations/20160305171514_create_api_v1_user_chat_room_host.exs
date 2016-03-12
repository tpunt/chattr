defmodule Chattr.Repo.Migrations.CreateApi.V1.User.ChatRoom.Host do
  use Ecto.Migration

  def change do
    create table(:hosts) do
      add :uri, :string
      add :bg_colour, :string
      add :text_colour, :string
      add :chat_room_id, references(:chat_rooms)

      timestamps
    end
    create index(:hosts, [:chat_room_id])

  end
end
