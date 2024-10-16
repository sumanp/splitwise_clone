defmodule SplitwiseClone.Accounts.User do
  use Ash.Resource,
    domain: SplitwiseClone.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  require Ash.Query
  alias Ash.Query

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
    calculate :total_amount_you_owe, :float, expr(sum(user_expense_you_owe.amount))

    calculate :total_amount_owed, :float, expr(sum(user_expense_owed.amount))

    calculate :total_balance, :float, expr(total_amount_owed - total_amount_you_owe)
  end

  actions do
    defaults [:read, :destroy, update: :*]

    create :create do
      accept [:email, :hashed_password]
    end
  end

  def user_expense_you_owe(user_id) do
    expense_ids_to_exclude = get_payer_expense_ids(user_id)

    UserExpense
    |> Query.filter(:user_id == ^user_id)
    |> Query.filter(:expense_id not in ^expense_ids_to_exclude)
    |> Ash.read!()
  end

  def user_expense_owed(user_id) do
    expense_ids_to_include = get_payer_expense_ids(user_id)

    UserExpense
    |> Query.filter(:expense_id in ^expense_ids_to_include and :user_id != ^user_id)
    |> Ash.read!()
  end

  def get_payer_expense_ids(user_id) do
    User
    |> Query.filter(:id == ^user_id)
    |> Query.load(:payer_expenses)
    |> Ash.read_one!()
    |> case do
      nil -> []
      user -> user.payer_expenses |> Enum.map(& &1.id)
    end
  end
end
