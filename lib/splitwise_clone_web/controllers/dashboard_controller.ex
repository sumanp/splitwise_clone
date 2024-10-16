defmodule SplitwiseCloneWeb.DashboardController do
  use SplitwiseCloneWeb, :controller

  alias SplitwiseClone.Accounts.User
  require Ash.Query

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    current_user= current_user |> Ash.load!(:user_expenses)
    render(conn, "index.html", expense_owed: current_user.user_expenses)
  end
end
