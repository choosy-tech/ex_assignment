defmodule ExAssignment.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  @required_attrs [:title, :priority, :done]

  schema "todos" do
    field(:done, :boolean, default: false)
    field(:priority, :integer)
    field(:title, :string)

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
  end
end
