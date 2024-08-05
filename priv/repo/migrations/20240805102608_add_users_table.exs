defmodule Twix.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :nickname, :text
      add :email, :text
      add :age, :integer

      timestamps()
    end

    create unique_index(:users, [:nickname])
    create unique_index(:users, [:email])
  end
end
