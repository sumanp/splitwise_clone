defmodule SplitwiseClone.Expenses do
  use Ash.Domain

  resources do
    resource(SplitwiseClone.Expenses.Expense)
    resource(SplitwiseClone.Expenses.UserExpense)
  end
end
