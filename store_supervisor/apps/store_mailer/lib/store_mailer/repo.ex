defmodule StoreMailer.Repo do
  use Ecto.Repo, otp_app: :store_mailer, adapter: Mongo.Ecto
end
