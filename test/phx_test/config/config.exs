# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :phx_test, PhxTestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "61kDYn6sAjwc5TW0vqkrNiQpvVd5+PKw1HNmBVRnHt/Bg7jWLn4uJwB7/2quS8e5",
  render_errors: [view: PhxTestWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhxTest.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
