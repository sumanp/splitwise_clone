defmodule SplitwiseCloneWeb.UserHTML do
  @moduledoc """
  This module contains pages rendered by UserController.

  See the `user_html` directory for all templates available.
  """
  use SplitwiseCloneWeb, :html

  embed_templates "../templates/user_html/*"
end
