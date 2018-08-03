defmodule Store.Product do
  import Ecto.Changeset
  import Ecto.Query
  use Store.Web, :model

  @primary_key {:_id, :binary_id, autogenerate: true}

  @derive {Poison.Encoder,
           only: [:_id, :sku, :product_name, :description, :amount, :price, :barcode]}
  @derive {Phoenix.Param, key: :_id}

  schema "products" do
    field(:sku, :string)
    field(:product_name, :string)
    field(:description, :string)
    field(:amount, :integer, default: 0)
    field(:price, :float)
    field(:barcode, :string)

    # timestamps()
  end

  def clear_db do
    Store.Product |> Store.Repo.delete_all()
  end

  def insert_product(attrs) do
    Store.Repo.insert(struct(Store.Product, attrs))
  end

  def list_all() do
    query = from(p in Store.Product, select: p)
    Store.Repo.all(query)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:sku, :product_name, :description, :amount, :price, :barcode])
    |> validate_required([:sku, :product_name, :amount, :price])
    |> validate_format(:sku, ~r/^[a-zA-Z]{4}\-\d{4}$/i)
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> validate_number(:price, greater_than_or_equal_to: 0.01)
    |> validate_format(:barcode, ~r/^\d{8,13}$/)
  end
end
