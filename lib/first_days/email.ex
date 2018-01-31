defmodule FirstDays.Email do
  use Bamboo.Phoenix, view: FirstDaysWeb.EmailView

  def welcome_email do
    new_email()
    |> to("ivan@wearecast.org.uk")
    |> from("ivan@wearecast.org.uk")
    |> subject("Welcome to the service!")
    |> render(:email)
  end
end
