FactoryBot.define do
  factory :food do
    sequence(:name) { |n| "Food #{n}" }
    serving_size_qty { 100 }
    serving_size_unit { "g" }
    calories { 165 }
    protein_g { 31 }
    carbs_g { 0 }
    fat_g { 3.6 }
    source { :database }
  end
end
