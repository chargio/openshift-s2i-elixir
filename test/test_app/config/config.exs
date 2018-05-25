# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :test_app, TestAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EFds29b8ctd7CVK5GRo/6s+R2B8Jxq1nBlsENPgLj+Xzpujx2rwzC+n9wuAV0R03",
  render_errors: [view: TestAppWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TestApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
