defmodule ExAssignment.TodosTest do
  use ExAssignment.DataCase

  import ExAssignment.TodosFixtures

  alias ExAssignment.Todos
  alias ExAssignment.Todos.Todo

  describe "todos" do
    @invalid_attrs %{done: nil, priority: nil, title: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{done: true, priority: 42, title: "some title"}

      assert {:ok, %Todo{} = todo} = Todos.create_todo(valid_attrs)
      assert todo.done == true
      assert todo.priority == 42
      assert todo.title == "some title"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{done: false, priority: 43, title: "some updated title"}

      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, update_attrs)
      assert todo.done == false
      assert todo.priority == 43
      assert todo.title == "some updated title"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo(todo, @invalid_attrs)
      assert todo == Todos.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Todos.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end

  describe "get_recommended/0" do
    test "returns all open todos" do
      open_todo = todo_fixture(%{done: false})
      _done_todo = todo_fixture(%{done: true})

      assert Todos.list_todos(:open) == [open_todo]
    end

    test "returns all todos with ascending pritority order" do
      # given
      open_todo_1 = todo_fixture(%{done: false, priority: 20})
      open_todo_2 = todo_fixture(%{done: true, priority: 40})

      # when
      assert Todos.list_todos() == [open_todo_1, open_todo_2]
    end
  end
  describe "probability/2" do
    test "returns correct probability for Prepare lunch" do
      # given
      todos = seed_todo()
      prepare_lunch = Enum.at(todos, 0)

      # when
      probability = Todos.probability(prepare_lunch, todos)

      # then
      assert probability == 0.529891304347826
    end

    test "returns correct probability for Water flowers" do
      # given
      todos = seed_todo()
      water_flowers = Enum.at(todos, 1)

      # when
      probability = Todos.probability(water_flowers, todos)

      # then
      assert probability == 0.21195652173913043
    end

    test "returns correct probability for Shop groceries" do
      # given
      todos = seed_todo()
      shop_groceries = Enum.at(todos, 2)

      # when
      probability = Todos.probability(shop_groceries, todos)

      # then
      assert probability == 0.17663043478260868
    end

    test "returns correct probability for Buy new flower pots" do
      # given
      todos = seed_todo()
      buy_new_flower_pots = Enum.at(todos, 3)

      # when
      probability = Todos.probability(buy_new_flower_pots, todos)

      # then
      assert probability == 0.08152173913043478
    end
  end

  defp seed_todo() do
    todo1 = todo_fixture(%{title: "Prepare lunch", priority: 20})
    todo2 = todo_fixture(%{title: "Water flowers", priority: 50})
    todo3 = todo_fixture(%{title: "Shop groceries", priority: 60})
    todo4 = todo_fixture(%{title: "Buy new flower pots", priority: 130})

    [todo1, todo2, todo3, todo4]
  end
end
