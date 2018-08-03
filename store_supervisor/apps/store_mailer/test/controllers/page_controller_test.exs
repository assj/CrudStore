defmodule StoreMailer.PageControllerTest do
  use StoreMailer.ConnCase

  @sample_file_content "_id,sku,barcode,product_name,description,amount,price\n5b6200c1d7e597024c0e2f67,LAPI-0000,00000000,Lápis,Para escrita temporária,500,1.0"

  test "GET /mailbox", %{conn: conn} do
    conn = get(conn, "/mailbox")
    assert html_response(conn, 200) =~ "Select an email"
  end

  test "POST /api/report", %{conn: conn} do
    temp_file_path = "temp_file.csv"
    temp_file = File.open!(temp_file_path, [:write, :utf8])
    File.write(temp_file_path, @sample_file_content)
    File.close(temp_file)

    conn = post(conn, "/api/report", file: temp_file_path)

    File.rm(temp_file_path)

    report_response = json_response(conn, 200)

    assert report_response["att_status"] == "ok"
    assert report_response["email_status"] == "ok"

    {:ok, att_file_content} = File.read(report_response["att_file_path"])

    assert @sample_file_content == att_file_content
  end
end
