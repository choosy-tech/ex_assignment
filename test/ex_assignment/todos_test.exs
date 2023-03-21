defmodule ExAssignment.TodosTest do
  use ExAssignment.DataCase

  alias ExAssignment.Todos

  describe "todos" do
    alias ExAssignment.Todos.Todo

    import ExAssignment.TodosFixtures

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

    test "get_recommendation/0 returns a recommended todo" do
      Enum.each(
        [
          %{
            done: false,
            priority: 20,
            title: "Prepare Lunch"
          }
        ],
        fn t ->
          todo_fixture(t)
        end
      )

      assert %{
               done: false,
               priority: 20,
               title: "Prepare Lunch"
             } = Todos.get_recommended()
    end

    test "get_recommendation/0 always returns same recommendation" do
      Enum.each(
        [
          %{
            done: false,
            priority: 20,
            title: "Prepare Lunch"
          },
          %{
            done: false,
            priority: 50,
            title: "Water flowers"
          }
        ],
        fn t ->
          todo_fixture(t)
        end
      )

      first_recommendation = Todos.get_recommended()

      for 1 <- 1..10 do
        assert first_recommendation.id == Todos.get_recommended().id
      end
    end

    test "get_recommendation/0 should not return the same recommendation if task was completed" do
      Enum.each(
        [
          %{
            done: false,
            priority: 20,
            title: "Prepare Lunch"
          },
          %{
            done: false,
            priority: 50,
            title: "Water flowers"
          },
          %{
            done: false,
            priority: 60,
            title: "Shop groceries"
          },
          %{
            done: false,
            priority: 130,
            title: "Buy new flower pots"
          }
        ],
        fn t ->
          todo_fixture(t)
        end
      )

      first_recommendation = Todos.get_recommended()
      Todos.check(first_recommendation.id)
      assert first_recommendation.id != Todos.get_recommended().id
    end

    test "calculate_recommendation/0 it should return based on priority " do
      attempts = 10000
      alpha = 0.05

      todos_list = [
        %{
          done: false,
          priority: 20,
          title: "Prepare Lunch"
        },
        %{
          done: false,
          priority: 50,
          title: "Water flowers"
        },
        %{
          done: false,
          priority: 60,
          title: "Shop groceries"
        },
        %{
          done: false,
          priority: 130,
          title: "Buy new flower pots"
        }
      ]

      Enum.each(
        todos_list,
        fn t ->
          todo_fixture(t)
        end
      )

      todos = Todos.list_todos(:open)

      [prepare_lunch, water_flowers, shop_groceries, buy_pots] =
        for todo <- todos_list do
          Enum.reduce(1..attempts, 0, fn _, acc ->
            if todo.title == Todos.calculate_recommendation(todos).title do
              acc + 1
            else
              acc
            end
          end)
        end

      probabilities = [
        prepare_lunch: prepare_lunch / attempts,
        water_flowers: water_flowers / attempts,
        shop_groceries: shop_groceries / attempts,
        buy_pots: buy_pots / attempts
      ]

      assert Float.floor(probabilities[:water_flowers] * 2.5 - probabilities[:prepare_lunch], 2) <=
               alpha

      assert Float.floor(probabilities[:shop_groceries] * 3 - probabilities[:prepare_lunch], 2) <=
               alpha

      assert Float.floor(probabilities[:buy_pots] * 6 - probabilities[:prepare_lunch], 2) <= alpha
    end
  end
end
