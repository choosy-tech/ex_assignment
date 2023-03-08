defmodule ExAssignment.Repo do
  use Ecto.Repo,
    otp_app: :ex_assignment,
    adapter: Ecto.Adapters.SQLite3
end
