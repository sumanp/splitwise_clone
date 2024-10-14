defmodule SplitwiseCloneWeb.DashboardHTML do
  @moduledoc """
  This module contains pages rendered by UserController.

  See the `dashboard_html` directory for all templates available.
  """
  use SplitwiseCloneWeb, :html

  embed_templates "../templates/dashboard_html/*"
end
