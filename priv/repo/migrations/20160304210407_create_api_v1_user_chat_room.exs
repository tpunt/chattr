defmodule Chattr.Repo.Migrations.CreateApi.V1.User.ChatRoom do
  use Ecto.Migration

  def change do
    create table(:chat_rooms) do
      add :name, :string
      add :user_id, references(:users)
      timestamps
    end

  end
end
