class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :name, null: false
      t.integer :age
      t.integer :biological_sex
      t.decimal :weight_kg, precision: 5, scale: 2
      t.decimal :height_cm, precision: 5, scale: 2
      t.integer :activity_level, null: false, default: 0
      t.integer :goal, null: false, default: 2
      t.integer :daily_calorie_target
      t.decimal :daily_protein_target_g, precision: 6, scale: 2
      t.decimal :daily_carbs_target_g, precision: 6, scale: 2
      t.decimal :daily_fat_target_g, precision: 6, scale: 2

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
