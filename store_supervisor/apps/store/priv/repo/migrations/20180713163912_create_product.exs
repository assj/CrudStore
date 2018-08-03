defmodule Store.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add(:sku, :string)
      add(:product_name, :string)
      add(:description, :text)
      add(:amount, :integer)
      add(:price, :float)

      timestamps()
    end
  end
end
