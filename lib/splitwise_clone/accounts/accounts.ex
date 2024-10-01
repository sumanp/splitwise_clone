defmodule SplitwiseClone.Accounts do
  use Ash.Domain

  resources do
    resource(SplitwiseClone.Accounts.User)
    resource(SplitwiseClone.Accounts.Token)
  end
end
