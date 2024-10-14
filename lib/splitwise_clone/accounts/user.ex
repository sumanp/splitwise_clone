defmodule SplitwiseClone.Accounts.User do
  use Ash.Resource,
    domain: SplitwiseClone.Accounts,
    data_layer: AshPostgres.DataLayer,
    # If using policies, enable the policy authorizer:
    # authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication]

  postgres do
    table "users"
    repo SplitwiseClone.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string do
      allow_nil? false
      public? true
    end

    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  authentication do
    strategies do
      password :password do
        identity_field :email
      end
    end

    tokens do
      enabled? true
      token_resource SplitwiseClone.Accounts.Token
      signing_secret SplitwiseClone.Accounts.Secrets
    end
  end

  identities do
    identity :unique_email, [:email]
  end

  relationships do
    has_many :payer_expenses, SplitwiseClone.Expenses.Expense, destination_attribute: :payer_id
    has_many :user_expenses, SplitwiseClone.Expenses.UserExpense, destination_attribute: :user_id

    many_to_many :expenses, SplitwiseClone.Expenses.Expense,
      through: SplitwiseClone.Expenses.UserExpense
  end

  calculations do
    calculate :total_amount_owed, :float, expr(sum(user_expenses.amount))

    calculate :total_amount_you_owe, :float, expr(sum(user_expenses.amount))

    calculate :total_balance, :float, expr(total_amount_owed - total_amount_you_owe)
  end

  actions do
    read :read_user
    update :update_user
  end
end
