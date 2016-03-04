defmodule Chattr.Repo.Migrations.CreateApi.V1.User.ChatRoom do
  use Ecto.Migration

  def change do
    create table(:chatrooms) do
      add :name, :string

      timestamps
    end

  end
end
