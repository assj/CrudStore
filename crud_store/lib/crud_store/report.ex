defmodule CrudStore.Report do
  alias CrudStore.Product

  def create() do
    products = Product.list_all()
    report_id = Ecto.UUID.generate()

    report_file_parent = Path.join(__DIR__, "reports")
    File.mkdir_p(report_file_parent)
    report_file_path = Path.join(report_file_parent, "report_#{report_id}.csv")

    report_file = File.open!(report_file_path, [:write, :utf8])

    products
    |> CSV.encode(headers: [:_id, :sku, :barcode, :product_name, :description, :amount, :price])
    |> Enum.each(&IO.write(report_file, &1))

    File.close(report_file)
    report_file_path
  end

  def convert_to_attrs_list(report_file_path) do
    report_file_contents =
      report_file_path
      |> File.stream!()
      |> CSV.decode()
      |> Enum.map(fn {k, v} -> v end)

    headers =
      hd(report_file_contents)
      |> Enum.map(fn x -> String.to_atom(x) end)

    rows = tl(report_file_contents)

    attrs_list = Enum.map(rows, fn x -> Enum.zip(headers, x) |> Enum.into(%{}) end)
  end
end
