defmodule DebugFly.Repo do
  use Ecto.Repo,
    otp_app: :debug_fly,
    adapter: Ecto.Adapters.Postgres
end
