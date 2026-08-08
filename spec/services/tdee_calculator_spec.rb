require "rails_helper"

RSpec.describe TdeeCalculator do
  describe "#targets" do
    it "returns nil targets when the user is missing weight, height, or age" do
      user = build(:user, weight_kg: nil)
      expect(TdeeCalculator.new(user).targets).to eq(
        calories: nil, protein_g: nil, carbs_g: nil, fat_g: nil
      )
    end

    it "computes calories/macros for a male user using Mifflin-St Jeor" do
      user = build(:user, biological_sex: :male, weight_kg: 80, height_cm: 180, age: 30,
                           activity_level: :moderately_active, goal: :maintain)

      # BMR = 10*80 + 6.25*180 - 5*30 + 5 = 1780; TDEE = 1780 * 1.55 = 2759
      targets = TdeeCalculator.new(user).targets
      expect(targets[:calories]).to eq(2759)
    end

    it "computes lower calories for a female user, all else equal" do
      male = build(:user, biological_sex: :male, weight_kg: 80, height_cm: 180, age: 30, activity_level: :sedentary, goal: :maintain)
      female = build(:user, biological_sex: :female, weight_kg: 80, height_cm: 180, age: 30, activity_level: :sedentary, goal: :maintain)

      expect(TdeeCalculator.new(female).targets[:calories]).to be < TdeeCalculator.new(male).targets[:calories]
    end

    it "applies a calorie deficit for a cut goal and a surplus for a bulk goal" do
      base = { biological_sex: :male, weight_kg: 80, height_cm: 180, age: 30, activity_level: :sedentary }
      maintain = TdeeCalculator.new(build(:user, **base, goal: :maintain)).targets[:calories]
      cut = TdeeCalculator.new(build(:user, **base, goal: :cut)).targets[:calories]
      bulk = TdeeCalculator.new(build(:user, **base, goal: :bulk)).targets[:calories]

      expect(cut).to be < maintain
      expect(bulk).to be > maintain
    end

    it "returns macros that roughly reconstruct total calories" do
      user = build(:user, biological_sex: :male, weight_kg: 80, height_cm: 180, age: 30,
                           activity_level: :moderately_active, goal: :maintain)
      targets = TdeeCalculator.new(user).targets
      reconstructed = (targets[:protein_g] * 4) + (targets[:carbs_g] * 4) + (targets[:fat_g] * 9)

      expect(reconstructed).to be_within(1.0).of(targets[:calories])
    end
  end
end
