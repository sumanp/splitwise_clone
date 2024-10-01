defmodule SplitwiseCloneWeb.Router do
  use SplitwiseCloneWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SplitwiseCloneWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  scope "/", SplitwiseCloneWeb do
    pipe_through :browser

    get "/", PageController, :home

    # Standard controller-backed routes
    auth_routes AuthController, SplitwiseClone.Accounts.User, path: "/auth"
    sign_out_route(AuthController)

    # Prebuilt LiveViews for signing in, registration, resetting, etc.
    # Leave out `register_path` and `reset_path` if you don't want to support
    # user registration and/or password resets respectively.
    sign_in_route(register_path: "/register", reset_path: "/reset", auth_routes_prefix: "/auth")
    reset_route auth_routes_prefix: "/auth"
  end

  # Other scopes may use custom stacks.
  # scope "/api", SplitwiseCloneWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:splitwise_clone, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SplitwiseCloneWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
