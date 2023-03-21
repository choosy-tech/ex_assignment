defmodule ExAssignment.Repo.Migrations.AlterTableTodosAddColumnRecommended do
  use Ecto.Migration

  def change do
    alter table(:todos) do
      add :recommended, :boolean, null: false, default: false
    end
  end
end
