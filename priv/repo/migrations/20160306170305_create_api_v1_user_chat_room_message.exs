defmodule Chattr.Repo.Migrations.CreateApi.V1.User.ChatRoom.Message do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :message, :string
      add :longitude, :decimal
      add :latitude, :decimal
      add :location, :string
      add :chat_room_id, references(:chat_rooms, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:messages, [:chat_room_id])
    create index(:messages, [:user_id])

  end
end
