defmodule SplitwiseClone.Repo do
  use Ecto.Repo,
    otp_app: :splitwise_clone,
    adapter: Ecto.Adapters.Postgres
end
