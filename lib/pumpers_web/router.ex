defmodule PumpersWeb.Router do
  use PumpersWeb, :router

  import PumpersWeb.UserAuth
  use PumpersWeb, :verified_routes

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PumpersWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug PumpersWeb.Plugs.Locale, "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PumpersWeb do
    pipe_through :browser

    get "/", PumpersController, :home
    get "/hello", PumpersController, :index
    get "/hello/:messenger", PumpersController, :show
  end

  scope "/", PumpersWeb do
    pipe_through [:browser, :require_powered_user_role]

    resources "/logs", LogsController, only: [:index, :show]
    resources "/monitors", MonitorsController, only: [:index, :show]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:pumpers, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PumpersWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", PumpersWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{PumpersWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", PumpersWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PumpersWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", PumpersWeb do
    pipe_through [:browser, :require_authenticated_user, :require_user_with_admin_role]

    live_session :require_user_with_admin_role,
      on_mount: [
        {PumpersWeb.UserAuth, :ensure_authenticated},
        {PumpersWeb.UserAuth, :require_user_with_admin_role}
      ] do
      live "/admin/users/live", AdminUsersLive
    end
  end

  scope "/", PumpersWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{PumpersWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  scope "/admin" do
    pipe_through [:browser, :require_authenticated_user, :require_user_with_admin_role]

    resources "/users", PumpersWeb.AdminUsersController, only: [:index, :edit]
  end

  ## Defult routes for all other requests
  # alias Pumpers.Live.AdminUsersLive
  alias PumpersWeb.NotFound
  match(:*, "/*funny_path", NotFound, :not_found)
end
