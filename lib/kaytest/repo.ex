defmodule Kaytest.Repo do
  use Ecto.Repo,
    otp_app: :kaytest,
    adapter: Ecto.Adapters.Postgres
end
