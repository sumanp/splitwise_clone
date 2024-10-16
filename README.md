# SplitwiseClone

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


<p>Total Balance: <%= @current_user.total_balance %> </p>
<p>You owe: <%= @current_user.total_amount_you_owe %> </p>
<p>You are owed: <%= @current_user.total_amount_owed %> </p>

<p> You Are Owed </p>
<%= if @current_user.user_expense_owed.present? do %>
  <%= for user_expense <- @current_user.user_expense_owed do %>
    <p> <%= user_expense.expense.payer.email %> | you owe $<%= user_expense.amount %></p>
  <% end %>
<% else %>
  <p> | Nobody owes you anything! </p>
<% end %>