require "rails_helper"

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "requires a unique, valid email" do
    create(:user, email: "taken@example.com")
    duplicate = build(:user, email: "taken@example.com")
    invalid_format = build(:user, email: "not-an-email")

    expect(duplicate).not_to be_valid
    expect(invalid_format).not_to be_valid
  end

  it "requires a name" do
    expect(build(:user, name: nil)).not_to be_valid
  end

  it "normalizes email to lowercase on save" do
    user = create(:user, email: "MixedCase@Example.com")
    expect(user.reload.email).to eq("mixedcase@example.com")
  end

  it "authenticates with the correct password" do
    user = create(:user, password: "correct-password")
    expect(user.authenticate("correct-password")).to eq(user)
    expect(user.authenticate("wrong-password")).to be false
  end

  it "defaults goal to maintain and exposes cut/bulk/maintain" do
    user = create(:user)
    expect(User.goals.keys).to contain_exactly("cut", "bulk", "maintain")
    expect(user.goal).to be_present
  end

  describe "#suggested_targets" do
    it "delegates to TdeeCalculator" do
      user = build(:user)
      expect(user.suggested_targets).to include(:calories, :protein_g, :carbs_g, :fat_g)
    end
  end

  describe "manual overrides" do
    it "prefers an explicit daily_calorie_target over the suggested value" do
      user = build(:user, daily_calorie_target: 1234)
      expect(user.daily_calorie_target_or_suggested).to eq(1234)
    end

    it "falls back to the suggested value when no override is set" do
      user = build(:user, daily_calorie_target: nil)
      expect(user.daily_calorie_target_or_suggested).to eq(user.suggested_targets[:calories])
    end
  end
end
