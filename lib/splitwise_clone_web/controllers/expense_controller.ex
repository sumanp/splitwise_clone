defmodule SplitwiseCloneWeb.ExpenseController do
  use SplitwiseCloneWeb, :controller

  alias SplitwiseClone.Expenses.Expense
  require Ash.Query
  alias Ash.Query

  def index(conn, _params) do
    expenses =
      Expense |> Query.load([:grand_total, :users, :user_expenses, :payer]) |> Ash.read!()

    render(conn, "index.html", expenses: expenses)
  end

  def new(conn, params) do
    changeset = Expense |> Ash.Changeset.for_create(:create_expense, params)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"expense" => expense_params}) do
    changeset = Expense |> Ash.Changeset.for_create(:create_expense, expense_params)

    case Ash.create(changeset) do
      {:ok, _expense} ->
        conn
        |> put_flash(:info, "Expense created successfully.")
        |> redirect(to: "/expenses")

      {:error, notifications} ->
        # Handle error notifications
        changeset =
          case List.first(notifications) do
            %Ash.Notifier.Notification{changeset: changeset} -> changeset
            # fallback to the original changeset if no changeset is in the notification
            _ -> changeset
          end

        # Render the new template with the error changeset
        render(conn, "new.html", changeset: changeset)
    end
  end
end
