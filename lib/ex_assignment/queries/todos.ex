defmodule ExAssignment.Queries.Todos do
  @moduledoc """
  Defines queries for working with Todos
  """

  import Ecto.Query, only: [where: 3, order_by: 3]

  alias ExAssignment.Todos.Todo

  @doc """
  Returns the base query for todos
  """
  @spec new() :: Ecto.Queryable.t()
  def new do
    Todo
    |> order_by([t], t.priority)
  end

  @doc """
  Returns a list of todos that have been marked as done

  ### Examples
  iex> completed()
  """
  @spec completed() :: Ecto.Query.t()
  @spec completed(query :: Ecto.Queryable.t()) :: Ecto.Query.t()
  def completed(query \\ new()) do
    query
    |> where([t], t.done == true)
  end

  @doc """
  Returns a list of todos that have not been marked as done

  ### Examples
  iex> not_completed()
  %Ecto.Query{}

  """
  @spec not_completed() :: Ecto.Query.t()
  @spec not_completed(query :: Ecto.Queryable.t()) :: Ecto.Query.t()
  def not_completed(query \\ new()) do
    query
    |> where([t], t.done == false)
  end
end
