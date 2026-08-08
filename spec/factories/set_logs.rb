FactoryBot.define do
  factory :set_log do
    workout_log
    exercise
    set_number { 1 }
    weight { 100 }
    reps { 10 }
    rpe { nil }
    is_pr { false }
  end
end
