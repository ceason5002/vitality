FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    name { "Test User" }
    age { 30 }
    biological_sex { :male }
    weight_kg { 80 }
    height_cm { 180 }
    activity_level { :moderately_active }
    goal { :maintain }
  end
end
