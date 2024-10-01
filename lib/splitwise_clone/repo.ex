defmodule SplitwiseClone.Repo do
  use AshPostgres.Repo, otp_app: :splitwise_clone

  def installed_extensions do
    ["uuid-ossp", "citext", "ash-functions"]
  end
end
