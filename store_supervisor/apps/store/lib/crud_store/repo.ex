defmodule Store.Repo do
  use Ecto.Repo, otp_app: :store, adapter: Mongo.Ecto
end
