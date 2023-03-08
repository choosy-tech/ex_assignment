defmodule ExAssignment.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExAssignment.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        done: true,
        priority: 42,
        title: "some title"
      })
      |> ExAssignment.Todos.create_todo()

    todo
  end
end
