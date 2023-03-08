defmodule ExAssignmentWeb.PageController do
  use ExAssignmentWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/todos")
  end
end
