defmodule W1.Repo.Migrations.AddHeartbeats do
  use Ecto.Migration

  def change do
    create table(:heartbeats, primary_key: false) do
      add :time, :timestamptz, null: false
      add :entity, :string, null: false
      add :type, :string, null: false
      add :category, :string
      add :project, :string
      add :branch, :string
      add :language, :string
      add :dependencies, {:array, :string}
      add :lines, :integer
      add :lineno, :integer
      add :cursorpos, :integer
      add :is_write, :boolean, null: false, default: false
      add :editor, :string
      add :operating_system, :string
    end
  end
end
