defmodule StoreMailer.Router do
  use StoreMailer.Web, :router

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

  scope "/" do
    pipe_through([:browser])
    forward("/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/mailbox")
  end

  # scope "/", StoreMailer do
  #   # Use the default browser stack
  #   pipe_through(:browser)

  #   get("/", PageController, :index)
  # end

  # Other scopes may use custom stacks.
  scope "/api", StoreMailer do
    pipe_through(:api)

    post("/report", PageController, :report)
  end
end
