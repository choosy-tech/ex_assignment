defmodule ExAssignment.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          title: String.t(),
          done: true | false,
          priority: pos_integer()
        }

  schema "todos" do
    field(:done, :boolean, default: false)
    field(:priority, :integer)
    field(:title, :string)

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :priority, :done])
    |> validate_required([:title, :priority, :done])
  end
end
