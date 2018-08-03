defmodule StoreMailer.PageController do
  use StoreMailer.Web, :controller

  alias StoreMailer.Email
  alias StoreMailer.Mailer

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def report(conn, %{"file" => %Plug.Upload{path: file_path}}) do
    report(conn, %{"file" => file_path})
  end

  def report(conn, %{"file" => file_path}) do
    att_file_path = create_report_attachment_path

    {att_status, _} = File.copy(file_path, att_file_path)

    attachment = Swoosh.Attachment.new(att_file_path, type: "attachment")

    built_email =
      Email.build_email(
        {"Me", "me@me.com"},
        "report@report.com",
        "Reports",
        "A report",
        attachment
      )

    {email_status, _} = built_email |> Mailer.deliver()

    json(conn, %{att_status: att_status, email_status: email_status, att_file_path: att_file_path})
  end

  defp create_report_attachment_path do
    report_id = Ecto.UUID.generate()

    report_file_parent = Path.join(__DIR__, "reports")
    File.mkdir_p(report_file_parent)
    Path.join(report_file_parent, "report_attachment_#{report_id}.csv")
  end
end
