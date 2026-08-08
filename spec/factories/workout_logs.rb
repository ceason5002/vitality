FactoryBot.define do
  factory :workout_log do
    user
    workout_template { nil }
    started_at { Time.current }
    completed_at { nil }
  end
end
