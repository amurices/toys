defmodule Characters.Repo.Migrations.AddCharacter do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :name, :string
      add :strength, :int
      add :agility, :int
      add :intelligence, :int
      add :arbitration, :int
      add :resourcefulness, :int
      add :magic, :int
    end
  end
end
