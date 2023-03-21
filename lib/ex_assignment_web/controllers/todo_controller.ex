defmodule ExAssignmentWeb.TodoController do
  use ExAssignmentWeb, :controller

  alias ExAssignment.Todos
  alias ExAssignment.Todos.Todo

  def index(conn, _params) do
    open_todos = Todos.list_todos(:open)
    done_todos = Todos.list_todos(:done)
    recommended_todo = Todos.get_recommended()

    render(conn, :index,
      open_todos: open_todos,
      done_todos: done_todos,
      recommended_todo: recommended_todo
    )
  end

  def new(conn, _params) do
    changeset = Todos.change_todo(%Todo{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"todo" => todo_params}) do
    case Todos.create_todo(todo_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Todo created successfully.")
        |> redirect(to: ~p"/todos")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    render(conn, :show, todo: todo)
  end

  def edit(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    changeset = Todos.change_todo(todo)
    render(conn, :edit, todo: todo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Todos.get_todo!(id)

    case Todos.update_todo(todo, todo_params) do
      {:ok, todo} ->
        IO.inspect(todo_params)

        conn
        |> put_flash(:info, "Todo updated successfully.")
        |> redirect(to: ~p"/todos/#{todo}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, todo: todo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    {:ok, _todo} = Todos.delete_todo(todo)

    conn
    |> put_flash(:info, "Todo deleted successfully.")
    |> redirect(to: ~p"/todos")
  end

  def check(conn, %{"id" => id}) do
    :ok = Todos.check(id)

    conn
    |> redirect(to: ~p"/todos")
  end

  def uncheck(conn, %{"id" => id}) do
    :ok = Todos.uncheck(id)

    conn
    |> redirect(to: ~p"/todos")
  end
end
