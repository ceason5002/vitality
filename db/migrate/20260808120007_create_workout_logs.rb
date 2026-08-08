class CreateWorkoutLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :workout_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :workout_template, foreign_key: true, null: true
      t.datetime :started_at, null: false
      t.datetime :completed_at

      t.timestamps
    end
    add_index :workout_logs, [:user_id, :started_at]
  end
end
