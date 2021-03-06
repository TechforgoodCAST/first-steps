defmodule FirstDaysWeb.PageController do
  use FirstDaysWeb, :controller
  plug :authenticate_user when action in [:landing, :get_them_ready]
  alias FirstDays.Accounts.User

  def index(%{assigns: %{current_user: %User{}}} = conn, _params) do
    conn
    |> redirect(to: page_path(conn, :landing))
  end

  def index(conn, _params) do
    conn
    |> redirect(to: session_path(conn, :new))
  end

  def landing(conn, _params) do
    render conn, "landing.html"
  end

  def get_them_ready(conn, _params) do
    render conn, "get_them_ready.html"
  end

  def about(conn, _params) do
    render conn, "about.html"
  end
end
