require "rails_helper"

RSpec.describe Food, type: :model do
  it "has a valid factory" do
    expect(build(:food)).to be_valid
  end

  it "requires a name and non-negative macros" do
    expect(build(:food, name: nil)).not_to be_valid
    expect(build(:food, calories: -1)).not_to be_valid
    expect(build(:food, protein_g: -1)).not_to be_valid
  end

  describe ".search" do
    it "matches by name or brand, case-insensitively" do
      match = create(:food, name: "Chicken Breast", brand: "Acme")
      create(:food, name: "Salmon", brand: "Ocean Co")

      expect(Food.search("chicken")).to contain_exactly(match)
      expect(Food.search("acme")).to contain_exactly(match)
    end
  end
end
