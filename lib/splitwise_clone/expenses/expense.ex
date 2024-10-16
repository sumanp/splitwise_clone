defmodule SplitwiseClone.Expenses.Expense do
  use Ash.Resource,
    domain: SplitwiseClone.Expenses,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "expenses"
    repo SplitwiseClone.Repo
  end

  attributes do
    uuid_primary_key :id
    attribute :payer_id, :uuid
    attribute :description, :string, allow_nil?: false
    attribute :amount, :float, allow_nil?: false
  end

  relationships do
    belongs_to :payer, SplitwiseClone.Accounts.User, source_attribute: :payer_id
    has_many :user_expenses, SplitwiseClone.Expenses.UserExpense

    many_to_many :users, SplitwiseClone.Accounts.User,
      through: SplitwiseClone.Expenses.UserExpense
  end

  calculations do
    calculate :grand_total, :float, expr(amount)
  end

  actions do
    defaults [:read, :destroy, update: :*]

    create :create_expense do
      accept [:description, :amount, :payer_id]

      after_action(:include_payer_in_expenses)
      after_action(:calculate_user_expense_amounts)
    end
  end

  defp include_payer_in_expenses(changeset, _context) do
    Ash.Changeset.create_related(changeset, :user_expenses, %{user_id: changeset.data.payer_id})
  end

  defp calculate_user_expense_amounts(changeset, _context) do
    user_expenses = changeset.data.user_expenses
    total_users = length(user_expenses) + 1
    individual_amount = changeset.data.amount / total_users

    user_expenses
    |> Enum.each(fn user_expense ->
      Ash.Changeset.change(user_expense, %{
        amount: individual_amount
      })
      |> Ash.Changeset.save!()
    end)

    changeset
  end
end
