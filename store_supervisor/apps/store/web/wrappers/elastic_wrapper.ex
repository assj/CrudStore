defmodule Store.ElasticWrapper do
  import Tirexs.Search
  import Tirexs.HTTP

  alias Store.Product

  def search_products(nil), do: search_products("")

  def search_products(search_string) do
    query =
      search index: "products" do
        query do
          multi_match(search_string, ["sku", "product_name", "description"])
        end
      end

    case Tirexs.Query.create_resource(query) do
      {:ok, _, %{hits: %{hits: search_result}}} -> search_result_to_product_list(search_result)
      _ -> []
    end
  end

  def put_product(product_id, product_params) do
    put("/products/product/" <> product_id, product_params)
  end

  def del_product(product_id) do
    delete("/products/product/" <> product_id)
  end

  defp search_result_to_product_list(search_result) do
    search_result
    |> Enum.map(&Map.put(&1[:_source], :_id, &1[:_id]))
    |> Enum.map(fn x -> struct(Product, x) end)
  end
end
