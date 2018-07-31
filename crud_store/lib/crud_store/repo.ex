defmodule CrudStore.Repo do
  use Ecto.Repo, otp_app: :crud_store, adapter: Mongo.Ecto
end
