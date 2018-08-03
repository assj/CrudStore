defmodule Store.Router do
  use Store.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", Store do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", ProductController, :index)
    get("/products/report", ProductController, :report)
    resources("/products", ProductController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", Store do
  #   pipe_through :api
  # end
end
