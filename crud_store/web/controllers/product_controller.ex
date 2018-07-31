defmodule CrudStore.ProductController do
  use CrudStore.Web, :controller

  alias CrudStore.Product
  alias CrudStore.RedisWrapper
  alias CrudStore.ElasticWrapper
  alias CrudStore.ReportWorker

  def index(conn, params) do
    products = search_products(params)

    if length(products) == 0 do
      products = Repo.all(Product)
    end

    render(conn, "index.html", products: products)
  end

  def new(conn, _params) do
    changeset = Product.changeset(%Product{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product" => product_params}) do
    changeset = Product.changeset(%Product{}, product_params)

    Repo.insert(changeset)
    |> IO.inspect()
    |> update_indices_and_redirect(nil, conn, "new.html", product_params)
  end

  def show(conn, %{"id" => id}) do
    product = RedisWrapper.get_product(id)

    if product == :undefined do
      product = Repo.get!(Product, id)
      RedisWrapper.set_product(product)
    end

    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)
    changeset = Product.changeset(product)
    render(conn, "edit.html", product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Repo.get!(Product, id)
    changeset = Product.changeset(product, product_params)

    Repo.update(changeset)
    |> IO.inspect()
    |> update_indices_and_redirect(product, conn, "edit.html", product_params)
  end

  def delete(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)

    Repo.delete!(product)
    RedisWrapper.del_product(id)
    ElasticWrapper.del_product(id)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: product_path(conn, :index))
  end

  def report(conn, _params) do
    {:ok, _} = Exq.enqueue(Exq, "default", ReportWorker, [])

    conn
    |> put_flash(:info, "Report successfully required")
    |> redirect(to: product_path(conn, :index))
  end

  defp update_indices_and_redirect({:error, changeset}, product, conn, page, _product_params),
    do: render(conn, page, product: product, changeset: changeset)

  defp update_indices_and_redirect({:ok, product}, _product, conn, _page, product_params) do
    RedisWrapper.set_product(product)
    ElasticWrapper.put_product(product._id, product_params)

    conn
    |> put_flash(:info, "Product updated successfully.")
    |> redirect(to: product_path(conn, :show, product._id))
  end

  defp search_products(params) do
    search_string = get_in(params, ["query"])
    ElasticWrapper.search_products(search_string)
  end
end
