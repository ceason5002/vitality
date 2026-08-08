FactoryBot.define do
  factory :food_log do
    user
    food
    logged_at { Time.current }
    servings { 1 }
    meal_type { :lunch }
  end
end
