defmodule StoreMailer.Email do
  import Swoosh.Email

  def build_email(from, to, subject, body, nil) do
    new
    |> from(from)
    |> to(to)
    |> subject(subject)
    |> text_body(body)
  end

  def build_email(from, to, subject, body, attachment) do
    new
    |> from(from)
    |> to(to)
    |> subject(subject)
    |> text_body(body)
    |> attachment(attachment)
  end
end
