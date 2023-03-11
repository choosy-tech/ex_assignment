defmodule ExAssignment.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExAssignment.Todos` context.
  """

  alias ExAssignment.Todos.Todo
  alias ExAssignment.Todos

  @doc """
  Generate a todo.
  """
  @spec todo_fixture(attrs :: map()) :: Todo.t()
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        done: true,
        priority: 42,
        title: "some title"
      })
      |> Todos.create_todo()

    todo
  end
end
