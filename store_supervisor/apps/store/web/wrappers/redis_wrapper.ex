defmodule Store.RedisWrapper do
  alias Store.Product

  def get_product(product_id) do
    {:ok, client} = Exredis.start_link()
    product = client |> Exredis.Api.get("products:" <> product_id)
    client |> Exredis.stop()

    case product do
      :undefined -> product
      _ -> Poison.decode!(product, as: %Product{})
    end
  end

  def set_product(product) do
    {:ok, client} = Exredis.start_link()
    client |> Exredis.Api.set("products:" <> product._id, Poison.encode!(product))
    client |> Exredis.stop()
  end

  def del_product(product_id) do
    {:ok, client} = Exredis.start_link()
    client |> Exredis.Api.del("products:" <> product_id)
    client |> Exredis.stop()
  end
end
