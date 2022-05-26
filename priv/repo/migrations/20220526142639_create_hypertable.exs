defmodule W1.Repo.Migrations.CreateHypertable do
  use Ecto.Migration

  def change do
    execute "SELECT create_hypertable('heartbeats', 'time')", ""
  end
end
