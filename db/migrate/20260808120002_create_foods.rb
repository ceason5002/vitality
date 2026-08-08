class CreateFoods < ActiveRecord::Migration[7.2]
  def change
    create_table :foods do |t|
      t.string :name, null: false
      t.string :brand
      t.decimal :serving_size_qty, precision: 8, scale: 2, null: false, default: 1
      t.string :serving_size_unit, null: false, default: "serving"
      t.decimal :calories, precision: 8, scale: 2, null: false
      t.decimal :protein_g, precision: 8, scale: 2, null: false, default: 0
      t.decimal :carbs_g, precision: 8, scale: 2, null: false, default: 0
      t.decimal :fat_g, precision: 8, scale: 2, null: false, default: 0
      t.integer :source, null: false, default: 0
      t.references :created_by_user, foreign_key: { to_table: :users }, null: true

      t.timestamps
    end
    add_index :foods, :name
  end
end
