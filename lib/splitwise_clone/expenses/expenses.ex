defmodule SplitwiseClone.Expenses do
  use Ash.Domain

  resources do
    resource(SplitwiseClone.Expenses.Expense)
  end
end
