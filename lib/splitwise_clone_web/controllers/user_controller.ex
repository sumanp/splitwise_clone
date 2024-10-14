defmodule SplitwiseCloneWeb.UserController do
  use SplitwiseCloneWeb, :controller

  alias SplitwiseClone.Accounts.User
  alias SplitwiseClone.Repo

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end
end
