class CreateSetLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :set_logs do |t|
      t.references :workout_log, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :set_number, null: false
      t.decimal :weight, precision: 6, scale: 2, null: false
      t.integer :reps, null: false
      t.decimal :rpe, precision: 3, scale: 1
      t.boolean :is_pr, null: false, default: false

      t.timestamps
    end
    add_index :set_logs, [:exercise_id, :created_at]
  end
end
