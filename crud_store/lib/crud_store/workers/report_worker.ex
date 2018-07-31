defmodule CrudStore.ReportWorker do
  alias CrudStore.Report

  def perform() do
    Report.create()
  end
end
