defmodule FirstDaysWeb.PreparationController do
  use FirstDaysWeb, :controller
  alias FirstDays.{Preparation, Accounts, Email, Mailer}

  def new(conn, _params) do
    changeset = Preparation.changeset(%Preparation{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_user: user}} = conn, %{"preparation" => preparation}) do
    case Preparation.validate_form(%Preparation{}, preparation) do
      {:ok, _preparation_changeset} ->
        preparation_changeset = Preparation.changeset(%Preparation{}, preparation)
        case Accounts.update_user_answers(user, %{preparation: preparation}) do
          {:ok, _answer} ->
            conn
            |> redirect(to: preparation_path(conn, :show))
          {:error, _changeset} ->
            conn
            |> put_flash(:error, gettext("Something went wrong, please try again"))
            |> render("new.html", changeset: preparation_changeset)
        end
      {:error, preparation_changeset} ->
        render(conn, "new.html", changeset: preparation_changeset)
    end
  end

  def show(%{assigns: %{current_user: user}} = conn, _params) do
    render(conn, "show.html", answers: user.preparation)
  end

  def edit(%{assigns: %{current_user: user}} = conn, _params) do
    changeset =
      user
      |> Map.get(:preparation)
      |> Map.from_struct
      |> (&Preparation.changeset(%Preparation{}, &1)).()
    render(conn, "edit.html", changeset: changeset)
  end

  def update(%{assigns: %{current_user: user}} = conn, %{"preparation" => preparation}) do
    case Preparation.validate_form(%Preparation{}, preparation) do
      {:ok, _preparation_changeset} ->
        preparation_changeset = Preparation.changeset(%Preparation{}, preparation)
        case Accounts.update_user_answers(user, %{preparation: preparation}) do
          {:ok, _answer} ->
            conn
            |> redirect(to: preparation_path(conn, :show))
          {:error, _changeset} ->
            conn
            |> put_flash(:error, gettext("Something went wrong, please try again"))
            |> render("edit.html", changeset: preparation_changeset)
        end
      {:error, preparation_changeset} ->
        render(conn, "edit.html", changeset: preparation_changeset)
    end
  end

  def email(%{assigns: %{current_user: user}} = conn, _params) do
    Email.preparation_email(%{current_user: user, answers: user.preparation})
    |> Mailer.deliver_later

    updated_stage = %{"preparation" => true}
    updated_stages = Map.merge(user.stages, updated_stage)

    case Accounts.update_user_stage(user, %{stages: updated_stages}) do
      {:ok, _user} ->
        conn
        |> put_flash(:email_modal, :preparation)
        |> redirect(to: page_path(conn, :get_them_ready))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, gettext("Something went wrong, please try again"))
        |> redirect(to: page_path(conn, :get_them_ready))
    end
  end
end
