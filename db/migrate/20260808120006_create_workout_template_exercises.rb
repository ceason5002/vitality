class CreateWorkoutTemplateExercises < ActiveRecord::Migration[7.2]
  def change
    create_table :workout_template_exercises do |t|
      t.references :workout_template, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :position, null: false
      t.integer :target_sets, null: false
      t.integer :target_reps_min, null: false
      t.integer :target_reps_max, null: false

      t.timestamps
    end
    add_index :workout_template_exercises, [:workout_template_id, :position]
  end
end
