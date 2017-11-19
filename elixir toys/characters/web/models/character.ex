defmodule Characters.Character do
  use Characters.Web, :model

  schema "characters" do
    field :name, :string
    field :strength, :integer
    field :agility, :integer
    field :intelligence, :integer
    field :arbitration, :integer
    field :resourcefulness, :integer
    field :magic, :integer
#    belongs_to :user, Discuss.User
#    has_many :comments, Discuss.Comment
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :strength, :agility, :intelligence, :arbitration, :resourcefulness, :magic])
    |> validate_required([:name, :strength, :agility, :intelligence, :arbitration, :resourcefulness, :magic])
    |> validate_inclusion(:strength, 0..10)
    |> validate_inclusion(:agility, 0..10)
    |> validate_inclusion(:intelligence, 0..10)
    |> validate_inclusion(:arbitration, 0..10)
    |> validate_inclusion(:resourcefulness, 0..10)
    |> validate_inclusion(:magic, 0..10)
  end
end
