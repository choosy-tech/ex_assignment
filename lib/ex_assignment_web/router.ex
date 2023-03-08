defmodule ExAssignmentWeb.Router do
  use ExAssignmentWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {ExAssignmentWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/", ExAssignmentWeb do
    pipe_through(:browser)

    get("/", PageController, :home)

    scope "/todos" do
      put("/:id/check", TodoController, :check)
      put("/:id/uncheck", TodoController, :uncheck)
      resources("/", TodoController)
    end
  end
end
