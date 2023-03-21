defmodule ExAssignment.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "todos" do
    field(:done, :boolean, default: false)
    field(:priority, :integer)
    field(:title, :string)
    field(:recommended, :boolean, default: false)

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :priority, :recommended, :done])
    |> validate_required([:title, :priority, :done])
  end
end
