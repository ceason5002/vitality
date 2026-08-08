FactoryBot.define do
  factory :workout_template_exercise do
    workout_template
    exercise
    position { 1 }
    target_sets { 3 }
    target_reps_min { 8 }
    target_reps_max { 10 }
  end
end
