defmodule SplitwiseCloneWeb.PageController do
  use SplitwiseCloneWeb, :controller
  use AshAuthentication.Phoenix.Controller
  alias SplitwiseClone.Accounts

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
