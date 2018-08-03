defmodule Store.ProductControllerTest do
  use Store.ConnCase

  alias Store.Product
  alias Store.Report

  @invalid_attrs %{
    amount: -1,
    description: "Some description",
    price: 0.00,
    product_name: "Some product",
    sku: "invalid sku",
    barcode: "invalid barcode"
  }

  @invalid_id "000000000000000000000000"

  setup do
    Product.clear_db()

    valid_attrs = %{
      amount: 0,
      description: "Description",
      price: 0.01,
      product_name: "Test product",
      sku: "TEST-1234",
      barcode: "01234567"
    }

    another_valid_attrs = %{
      amount: 1,
      description: "Another description",
      price: 0.02,
      product_name: "Another test product",
      sku: "TEST-0000",
      barcode: "00000000"
    }

    [another_valid_attrs: another_valid_attrs, valid_attrs: valid_attrs]
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, product_path(conn, :index))
    assert html_response(conn, 200) =~ "Listing products"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get(conn, product_path(conn, :new))
    assert html_response(conn, 200) =~ "New product"
  end

  test "creates resource and redirects when data is valid", %{
    conn: conn,
    valid_attrs: valid_attrs
  } do
    conn = post(conn, product_path(conn, :create), product: valid_attrs)
    product = Repo.get_by!(Product, valid_attrs)
    assert redirected_to(conn) == product_path(conn, :show, product._id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, product_path(conn, :create), product: @invalid_attrs)
    assert html_response(conn, 200) =~ "New product"
  end

  test "shows chosen resource", %{conn: conn, valid_attrs: valid_attrs} do
    {:ok, product} = Product.insert_product(valid_attrs)
    conn = get(conn, product_path(conn, :show, product))
    assert html_response(conn, 200) =~ "Show product"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent(404, fn ->
      get(conn, product_path(conn, :show, @invalid_id))
    end)
  end

  test "renders form for editing chosen resource", %{conn: conn, valid_attrs: valid_attrs} do
    {:ok, product} = Product.insert_product(valid_attrs)

    conn = get(conn, product_path(conn, :edit, product))
    assert html_response(conn, 200) =~ "Edit product"
  end

  test "updates chosen resource and redirects when data is valid", %{
    conn: conn,
    another_valid_attrs: another_valid_attrs,
    valid_attrs: valid_attrs
  } do
    {:ok, product} = Product.insert_product(valid_attrs)
    product_id = product._id

    conn = put(conn, product_path(conn, :update, product), product: another_valid_attrs)
    assert redirected_to(conn) == product_path(conn, :show, product_id)

    product = Repo.get_by(Product, _id: product_id)

    assert product._id == product_id
    assert product.amount == another_valid_attrs[:amount]
    assert product.barcode == another_valid_attrs[:barcode]
    assert product.description == another_valid_attrs[:description]
    assert product.price == another_valid_attrs[:price]
    assert product.product_name == another_valid_attrs[:product_name]
    assert product.sku == another_valid_attrs[:sku]
  end

  test "does not update chosen resource and renders errors when data is invalid", %{
    conn: conn,
    valid_attrs: valid_attrs
  } do
    {:ok, product} = Product.insert_product(valid_attrs)
    conn = put(conn, product_path(conn, :update, product), product: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit product"
  end

  test "deletes chosen resource", %{conn: conn, valid_attrs: valid_attrs} do
    {:ok, product} = Product.insert_product(valid_attrs)
    conn = delete(conn, product_path(conn, :delete, product))
    assert redirected_to(conn) == product_path(conn, :index)
    refute Repo.get(Product, product._id)
  end

  test "checks if the report was requested successfully", %{conn: conn, valid_attrs: valid_attrs} do
    {:ok, product} = Product.insert_product(valid_attrs)
    conn = get(conn, product_path(conn, :report))
    assert redirected_to(conn) == product_path(conn, :index)
  end

  test "checks if the report file was correctly created", %{conn: conn, valid_attrs: valid_attrs} do
    {:ok, product} = Product.insert_product(valid_attrs)
    report_file_path = Report.create()

    attrs_list = Report.convert_to_attrs_list(report_file_path)
    attrs = Enum.at(attrs_list, 0)

    assert product._id == attrs[:_id]
    assert product.sku == attrs[:sku]
    assert product.barcode == attrs[:barcode]
    assert product.product_name == attrs[:product_name]
    assert product.description == attrs[:description]

    {attrs_amount, _} = Integer.parse(attrs[:amount])
    {attrs_price, _} = Float.parse(attrs[:price])

    assert product.amount == attrs_amount
    assert product.price == attrs_price
  end
end
