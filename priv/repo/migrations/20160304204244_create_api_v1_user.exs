defmodule Chattr.Repo.Migrations.CreateApi.V1.User do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_hash, :string
      add :authenticator, :string
      add :user_id, :string

      timestamps
    end

    create unique_index(:users, [:email])
  end
end
