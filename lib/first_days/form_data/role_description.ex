defmodule FirstDays.RoleDescription do
  use Ecto.Schema
  import Ecto.Changeset
  alias FirstDays.RoleDescription

  embedded_schema do
    field :additional_info, :string
    field :area, :string
    field :charity_number, :string
    field :contact_details, :string
    field :description, :string
    field :specific_skills, :string
    field :how_will_work_help, :string
    field :location, :string
    field :organisation_achievements, :string
    field :organisation_mission, :string
    field :organisation_name, :string
    field :role_title, :string
    field :skills_to_be_gained, :string
    field :website_link, :string
    field :work_frequency, :string
    field :work_length, :string
  end

  @fields [
          :role_title,
          :description,
          :area,
          :specific_skills,
          :additional_info,
          :work_frequency,
          :work_length,
          :location,
          :contact_details,
          :organisation_name,
          :organisation_mission,
          :organisation_achievements,
          :charity_number,
          :website_link,
          :how_will_work_help,
          :skills_to_be_gained
          ]

  @doc false
  def changeset(%RoleDescription{} = document_checklist, attrs) do
    document_checklist
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end

  def validate_form(%RoleDescription{} = struct, params) do
    change =
      struct
      |> changeset(params)
      |> update_embedded_action(:validated)

    case change do
      %Ecto.Changeset{valid?: true} = changeset ->
        {:ok, changeset}
      changeset ->
        {:error, changeset}
    end
  end

  defp update_embedded_action(changeset, action) do
    %{changeset | action: action}
  end
end
