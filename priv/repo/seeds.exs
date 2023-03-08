# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ExAssignment.Repo.insert!(%ExAssignment.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

ExAssignment.Repo.insert!(%ExAssignment.Todos.Todo{
  title: "water flowers",
  priority: 60,
  done: true
})

ExAssignment.Repo.insert!(%ExAssignment.Todos.Todo{
  title: "prepare lunch",
  priority: 20
})

ExAssignment.Repo.insert!(%ExAssignment.Todos.Todo{
  title: "prepare dinner",
  priority: 70
})

ExAssignment.Repo.insert!(%ExAssignment.Todos.Todo{
  title: "shop groceries",
  priority: 50
})

ExAssignment.Repo.insert!(%ExAssignment.Todos.Todo{
  title: "clean bathroom",
  priority: 75
})

ExAssignment.Repo.insert!(%ExAssignment.Todos.Todo{
  title: "make dentist appointment",
  priority: 90
})

ExAssignment.Repo.insert!(%ExAssignment.Todos.Todo{
  title: "walk the dog",
  priority: 30
})
