defmodule SplitwiseCloneWeb.DashboardController do
  use SplitwiseCloneWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
