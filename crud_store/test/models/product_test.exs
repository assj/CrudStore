defmodule CrudStore.ProductTest do
  use CrudStore.ModelCase

  alias CrudStore.Product

  @invalid_amount_list [-1]
  @invalid_price_list [0, -1]
  @invalid_product_name_list [nil, ""]
  @invalid_sku_list [nil, "", "ABC1-1234", "ABCD+1234"]
  @invalid_barcode_list ["0123456", "01234567890123", "0123456A"]

  @valid_attrs %{
    amount: 0,
    description: "Description",
    price: 0.01,
    product_name: "Test product",
    sku: "TEST-1234",
    barcode: "01234567"
  }

  @invalid_attrs %{}

  defp check_invalid_param(param_key, param_value_list) do
    case param_value_list do
      [] ->
        false

      _ ->
        attrs = Map.put(@valid_attrs, param_key, hd(param_value_list))
        changeset = Product.changeset(%Product{}, attrs)
        refute changeset.valid? or check_invalid_param(param_key, tl(param_value_list))
    end
  end

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid amounts" do
    check_invalid_param(:amount, @invalid_amount_list)
  end

  test "changeset with invalid prices" do
    check_invalid_param(:price, @invalid_price_list)
  end

  test "changeset with invalid product_names" do
    check_invalid_param(:product_name, @invalid_product_name_list)
  end

  test "changeset with invalid skus" do
    check_invalid_param(:sku, @invalid_sku_list)
  end

  test "changeset with invalid barcodes" do
    check_invalid_param(:barcode, @invalid_barcode_list)
  end
end
