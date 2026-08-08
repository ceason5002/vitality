class CreateFoodLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :food_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :food, null: false, foreign_key: true
      t.datetime :logged_at, null: false
      t.decimal :servings, precision: 6, scale: 2, null: false, default: 1
      t.integer :meal_type, null: false

      t.timestamps
    end
    add_index :food_logs, [:user_id, :logged_at]
  end
end
