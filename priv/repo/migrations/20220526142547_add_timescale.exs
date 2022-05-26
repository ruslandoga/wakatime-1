defmodule W1.Repo.Migrations.AddTimescale do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE",
            "DROP EXTENSION IF EXISTS timescaledb CASCADE"
  end
end
