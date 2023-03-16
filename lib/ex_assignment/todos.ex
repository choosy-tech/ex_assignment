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
  def list_todos(type \\ nil) do
    cond do
      type == :open ->
        from(t in Todo, where: not t.done, order_by: t.priority)
        |> Repo.all()

      type == :done ->
        from(t in Todo, where: t.done, order_by: t.priority)
        |> Repo.all()

      true ->
        from(t in Todo, order_by: t.priority)
        |> Repo.all()
    end
  end

  @doc """
  Returns the next todo that is recommended to be done by the system.

  ASSIGNMENT: ...
  """
  def get_recommended() do
    list_todos(:open)
    |> case do
      [] -> nil
      todo_list ->
        sorted_by_probability =
          todo_list
          |> calculate_probability()
          |> List.first()

      Enum.find(todo_list, &(&1.id == sorted_by_probability.id))
    end
  end

  # Calculate probablities for all todos
  def calculate_probability(todo_list) do
    todo_list
    |> Enum.map(fn todo ->
      %{id: todo.id, probablity: probability(todo, todo_list)}
    end)
  end

  # Count the probability of a todo item
  def probability(todo, todos) do
    urgency_score(todo) / Enum.reduce(todos, 0, fn t, acc -> acc + urgency_score(t) end)
  end

  # Calculate the urgency score of a todo item
  defp urgency_score(todo) do
    1 / todo.priority
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
  def get_todo!(id), do: Repo.get!(Todo, id)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end

  @doc """
  Marks the todo referenced by the given id as checked (done).

  ## Examples

      iex> check(1)
      :ok

  """
  def check(id) do
    {_, _} =
      from(t in Todo, where: t.id == ^id, update: [set: [done: true]])
      |> Repo.update_all([])

    :ok
  end

  @doc """
  Marks the todo referenced by the given id as unchecked (not done).

  ## Examples

      iex> uncheck(1)
      :ok

  """
  def uncheck(id) do
    {_, _} =
      from(t in Todo, where: t.id == ^id, update: [set: [done: false]])
      |> Repo.update_all([])

    :ok
  end
end
