defmodule SplitwiseCloneWeb.ExpenseHTML do
  @moduledoc """
  This module contains pages rendered by ExpenseController.

  See the `expense_html` directory for all templates available.
  """
  use SplitwiseCloneWeb, :html

  embed_templates "../templates/expense_html/*"
end
