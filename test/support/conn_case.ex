defmodule W1.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias W1.Repo
      import Plug.{Conn, Test}
      @endpoint W1.Endpoint
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
