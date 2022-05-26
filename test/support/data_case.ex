defmodule W1.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias W1.Repo

      import Ecto
      import Ecto.{Changeset, Query}
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(W1.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(W1.Repo, {:shared, self()})
    end

    :ok
  end
end
