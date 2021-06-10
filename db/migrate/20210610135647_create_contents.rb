class CreateContents < ActiveRecord::Migration[6.1]
  def change
    create_table :contents do |t|
      t.string :title, null: false
      t.text :plot, null: false
      t.integer :number
      t.references :parent, foreign_key: { to_table: :contents }
      t.string :type, null: false

      t.timestamps
    end
  end
end
