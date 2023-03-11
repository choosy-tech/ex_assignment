defmodule ExAssignment.Todos do
  @moduledoc """
  Provides operations for working with todos.
  """

  import Ecto.Query, warn: false
  alias ExAssignment.Repo

  alias ExAssignment.Todos.Todo

  @doc """
  Returns the list of todos, optionally filtered by the given type.

  ## Examples

      iex> list_todos(:open)
      [%Todo{}, ...]

      iex> list_todos(:done)
      [%Todo{}, ...]

      iex> list_todos()
      [%Todo{}, ...]

  """
  @spec list_todos(type :: atom()) :: [Todo.t()] | []
  def list_todos(:open) do
    from(t in Todo, where: not t.done, order_by: t.priority)
    |> Repo.all()
  end

  def list_todos(:done) do
    from(t in Todo, where: t.done, order_by: t.priority)
    |> Repo.all()
  end

  @spec list_todos() :: [Todo.t()] | []
  def list_todos do
    from(t in Todo, order_by: t.priority)
    |> Repo.all()
  end

  @doc """
  Returns the next todo that is recommended to be done by the system.

  ASSIGNMENT: ...
  """
  @spec get_recommended() :: Todo.t() | nil
  def get_recommended do
    list_todos(:open)
    |> case do
      [] -> nil
      todos -> Enum.take_random(todos, 1) |> List.first()
    end
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_todo!(id :: integer()) :: Todo.t() | no_return()
  def get_todo!(id), do: Repo.get!(Todo, id)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_todo(attrs :: map()) :: {:ok, Todo.t()} | {:error, Ecto.Changeset.t()}
  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_todo(todo :: Todo.t(), attrs :: map()) ::
          {:ok, Todo.t()} | {:error, Ecto.Changeset.t()}
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_todo(todo :: Todo.t()) :: {:ok, Todo.t()} | {:error, Ecto.Changeset.t()}
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  @spec change_todo(todo :: Todo.t(), attrs :: map()) :: Ecto.Changeset.t()
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end

  @doc """
  Marks the todo referenced by the given id as checked (done).

  ## Examples

      iex> check(1)
      :ok

  """
  @spec check(id :: integer()) :: :ok
  def check(id) do
    {_, _} = update_todo_state(id, true)

    :ok
  end

  @doc """
  Marks the todo referenced by the given id as unchecked (not done).

  ## Examples

      iex> uncheck(1)
      :ok

  """
  @spec uncheck(id :: integer()) :: :ok
  def uncheck(id) do
    {_, _} = update_todo_state(id, false)

    :ok
  end

  @spec update_todo_state(todo_id :: integer(), done? :: boolean()) ::
          {qty_of_todos_updated :: non_neg_integer(), result :: nil | [term()]}
  defp update_todo_state(todo_id, done?) do
    from(t in Todo, where: t.id == ^todo_id, update: [set: [done: ^done?]])
    |> Repo.update_all([])
  end
end
