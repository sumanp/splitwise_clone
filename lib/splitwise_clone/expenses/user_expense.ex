defmodule SplitwiseClone.Expenses.UserExpense do
  use Ash.Resource,
    domain: SplitwiseClone.Expenses,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "user_expenses"
    repo SplitwiseClone.Repo
  end

  attributes do
    uuid_primary_key :id
    attribute :amount, :float, allow_nil?: false
    attribute :expense_id, :uuid
    attribute :user_id, :uuid
  end

  relationships do
    belongs_to :expense, SplitwiseClone.Expenses.Expense
    belongs_to :user, SplitwiseClone.Accounts.User
  end

  validations do
    validate compare(:amount, greater_than_or_equal_to: 0) do
      message "must be greater than 0"
    end
  end

  actions do
    create :create_user_expense
    read :read_user_expense
    update :update_user_expense
  end
end
