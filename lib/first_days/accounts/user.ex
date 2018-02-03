defmodule FirstDays.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias FirstDays.{Accounts.User, RoleDescription, DocumentChecklist, Preparation}


  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :stages, {:map, :boolean}
    embeds_one :role_description, RoleDescription, on_replace: :update
    embeds_one :document_checklist, DocumentChecklist, on_replace: :update
    embeds_one :preparation, Preparation, on_replace: :update

    timestamps()
  end

  @stages %{
    "role_description" => false,
    "confirmation_agreement" => false,
    "document_checklist" => false,
    "preparation" => false,
    "feedback" => false
  }

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> unique_constraint(:email)
    |> validate_required([:name, :email, :password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
    |> put_change(:stages, @stages)
  end

  def answer_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [])
    |> Ecto.Changeset.cast_embed(:role_description)
    |> Ecto.Changeset.cast_embed(:document_checklist)
    |> Ecto.Changeset.cast_embed(:preparation)
  end

  def email_changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end


  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
      changeset
    end
  end
end
