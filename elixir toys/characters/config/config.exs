# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :characters,
  ecto_repos: [Characters.Repo]

# Configures the endpoint
config :characters, Characters.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pQrAfbXSJT7SHbXFIiD4pqjOBEE3yq5gXdiFr+hk876b61VaKa/4jqS0zOD4Z1tM",
  render_errors: [view: Characters.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Characters.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
