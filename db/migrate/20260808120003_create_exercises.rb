class CreateExercises < ActiveRecord::Migration[7.2]
  def change
    create_table :exercises do |t|
      t.string :name, null: false
      t.integer :muscle_group, null: false
      t.integer :equipment, null: false
      t.text :instructions

      t.timestamps
    end
    add_index :exercises, :name, unique: true
  end
end
