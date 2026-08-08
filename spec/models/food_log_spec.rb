require "rails_helper"

RSpec.describe FoodLog, type: :model do
  it "has a valid factory" do
    expect(build(:food_log)).to be_valid
  end

  it "requires positive servings" do
    expect(build(:food_log, servings: 0)).not_to be_valid
    expect(build(:food_log, servings: -1)).not_to be_valid
  end

  describe "totals" do
    it "scales food macros by the number of servings" do
      food = create(:food, calories: 200, protein_g: 20, carbs_g: 10, fat_g: 5)
      log = create(:food_log, food: food, servings: 2)

      expect(log.total_calories).to eq(400)
      expect(log.total_protein_g).to eq(40)
      expect(log.total_carbs_g).to eq(20)
      expect(log.total_fat_g).to eq(10)
    end
  end

  describe ".on_date" do
    it "only includes logs from the given date" do
      today_log = create(:food_log, logged_at: Time.zone.now)
      create(:food_log, logged_at: 2.days.ago)

      expect(FoodLog.on_date(Date.current)).to contain_exactly(today_log)
    end
  end
end
