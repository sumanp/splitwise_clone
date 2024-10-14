defmodule :"Elixir.SplitwiseClone.Repo.Migrations.Add resources" do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:user_expenses, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :amount, :float, null: false
      add :expense_id, :uuid
      add :user_id, :uuid
    end

    create table(:expenses, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
    end

    alter table(:user_expenses) do
      modify :expense_id,
             references(:expenses,
               column: :id,
               name: "user_expenses_expense_id_fkey",
               type: :uuid,
               prefix: "public"
             )

      modify :user_id,
             references(:users,
               column: :id,
               name: "user_expenses_user_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    alter table(:expenses) do
      add :payer_id,
          references(:users,
            column: :id,
            name: "expenses_payer_id_fkey",
            type: :uuid,
            prefix: "public"
          )

      add :description, :text, null: false
      add :amount, :float, null: false
    end
  end

  def down do
    drop constraint(:expenses, "expenses_payer_id_fkey")

    alter table(:expenses) do
      remove :amount
      remove :description
      remove :payer_id
    end

    drop constraint(:user_expenses, "user_expenses_expense_id_fkey")

    drop constraint(:user_expenses, "user_expenses_user_id_fkey")

    alter table(:user_expenses) do
      modify :user_id, :uuid
      modify :expense_id, :uuid
    end

    drop table(:expenses)

    drop table(:user_expenses)
  end
end
