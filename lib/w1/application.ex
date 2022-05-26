defmodule W1.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    repo_config = Application.fetch_env!(:w1, W1.Repo)
    endpoint_config = Application.fetch_env!(:w1, W1.Endpoint)
    http_options = Keyword.fetch!(endpoint_config, :http)

    children = [
      W1.Repo,
      {W1.Release.Migrator, migrate: repo_config[:migrate]},
      {Plug.Cowboy, scheme: :http, plug: W1.Endpoint, options: http_options}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: W1.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
