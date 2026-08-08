# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_08_08_120008) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exercises", force: :cascade do |t|
    t.string "name", null: false
    t.integer "muscle_group", null: false
    t.integer "equipment", null: false
    t.text "instructions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_exercises_on_name", unique: true
  end

  create_table "food_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "food_id", null: false
    t.datetime "logged_at", null: false
    t.decimal "servings", precision: 6, scale: 2, default: "1.0", null: false
    t.integer "meal_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_food_logs_on_food_id"
    t.index ["user_id", "logged_at"], name: "index_food_logs_on_user_id_and_logged_at"
    t.index ["user_id"], name: "index_food_logs_on_user_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string "name", null: false
    t.string "brand"
    t.decimal "serving_size_qty", precision: 8, scale: 2, default: "1.0", null: false
    t.string "serving_size_unit", default: "serving", null: false
    t.decimal "calories", precision: 8, scale: 2, null: false
    t.decimal "protein_g", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "carbs_g", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "fat_g", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "source", default: 0, null: false
    t.bigint "created_by_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_user_id"], name: "index_foods_on_created_by_user_id"
    t.index ["name"], name: "index_foods_on_name"
  end

  create_table "set_logs", force: :cascade do |t|
    t.bigint "workout_log_id", null: false
    t.bigint "exercise_id", null: false
    t.integer "set_number", null: false
    t.decimal "weight", precision: 6, scale: 2, null: false
    t.integer "reps", null: false
    t.decimal "rpe", precision: 3, scale: 1
    t.boolean "is_pr", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id", "created_at"], name: "index_set_logs_on_exercise_id_and_created_at"
    t.index ["exercise_id"], name: "index_set_logs_on_exercise_id"
    t.index ["workout_log_id"], name: "index_set_logs_on_workout_log_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "name", null: false
    t.integer "age"
    t.integer "biological_sex"
    t.decimal "weight_kg", precision: 5, scale: 2
    t.decimal "height_cm", precision: 5, scale: 2
    t.integer "activity_level", default: 0, null: false
    t.integer "goal", default: 2, null: false
    t.integer "daily_calorie_target"
    t.decimal "daily_protein_target_g", precision: 6, scale: 2
    t.decimal "daily_carbs_target_g", precision: 6, scale: 2
    t.decimal "daily_fat_target_g", precision: 6, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "workout_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "workout_template_id"
    t.datetime "started_at", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "started_at"], name: "index_workout_logs_on_user_id_and_started_at"
    t.index ["user_id"], name: "index_workout_logs_on_user_id"
    t.index ["workout_template_id"], name: "index_workout_logs_on_workout_template_id"
  end

  create_table "workout_template_exercises", force: :cascade do |t|
    t.bigint "workout_template_id", null: false
    t.bigint "exercise_id", null: false
    t.integer "position", null: false
    t.integer "target_sets", null: false
    t.integer "target_reps_min", null: false
    t.integer "target_reps_max", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_workout_template_exercises_on_exercise_id"
    t.index ["workout_template_id", "position"], name: "idx_on_workout_template_id_position_db27945069"
    t.index ["workout_template_id"], name: "index_workout_template_exercises_on_workout_template_id"
  end

  create_table "workout_templates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_workout_templates_on_user_id"
  end

  add_foreign_key "food_logs", "foods"
  add_foreign_key "food_logs", "users"
  add_foreign_key "foods", "users", column: "created_by_user_id"
  add_foreign_key "set_logs", "exercises"
  add_foreign_key "set_logs", "workout_logs"
  add_foreign_key "workout_logs", "users"
  add_foreign_key "workout_logs", "workout_templates"
  add_foreign_key "workout_template_exercises", "exercises"
  add_foreign_key "workout_template_exercises", "workout_templates"
  add_foreign_key "workout_templates", "users"
end
