defmodule Store.ReportWorker do
  alias Store.Report

  def perform() do
    Report.create()
    |> Report.send_to_mailer()
  end
end
