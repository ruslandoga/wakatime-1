import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

config :logger, :console, format: "$time [$level] $message\n"

if config_env() == :prod do
  config :logger, level: :info

  config :w1, W1.Repo,
    database: System.fetch_env!("DATABASE_URL"),
    migrate: true

  port = String.to_integer(System.get_env("PORT") || "4000")

  config :w1, W1.Endpoint,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ]
end

if config_env() == :dev do
  config :w1, W1.Repo,
    database: System.get_env("DATABASE_URL") || "ecto://postgres:postgres@localhost:5432/w1_dev",
    username: "postgres",
    password: "postgres",
    show_sensitive_data_on_connection_error: true,
    pool_size: 10

  config :w1, W1.Endpoint, http: [ip: {127, 0, 0, 1}, port: 4000]
end

if config_env() == :test do
  config :logger, level: :warn

  # Configure your database
  #
  # The MIX_TEST_PARTITION environment variable can be used
  # to provide built-in test partitioning in CI environment.
  # Run `mix help test` for more information.
  config :w1, W1.Repo,
    url: "ecto://postgres:postgres@localhost:5432/w1_test#{System.get_env("MIX_TEST_PARTITION")}",
    pool: Ecto.Adapters.SQL.Sandbox

  config :w1, W1.Endpoint, http: [ip: {127, 0, 0, 1}, port: 4002]
end
