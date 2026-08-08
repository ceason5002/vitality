FactoryBot.define do
  factory :exercise do
    sequence(:name) { |n| "Exercise #{n}" }
    muscle_group { :chest }
    equipment { :barbell }
    instructions { "Do the exercise." }
  end
end
