class CreatePurchaseOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :purchase_options do |t|
      t.decimal :price, precision: 8, scale: 2, null: false
      t.references :purchasable, polymorphic: true, null: false
      t.string :quality, null: false

      t.timestamps
    end
  end
end
