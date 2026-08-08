FactoryBot.define do
  factory :workout_template do
    user
    sequence(:name) { |n| "Template #{n}" }
    description { "A workout template." }
  end
end
