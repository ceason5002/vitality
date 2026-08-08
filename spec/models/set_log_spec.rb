require "rails_helper"

RSpec.describe SetLog, type: :model do
  it "has a valid factory" do
    expect(build(:set_log)).to be_valid
  end

  it "requires positive reps and a set number" do
    expect(build(:set_log, reps: 0)).not_to be_valid
    expect(build(:set_log, set_number: 0)).not_to be_valid
  end

  it "requires rpe to be between 0 and 10 when present" do
    expect(build(:set_log, rpe: 11)).not_to be_valid
    expect(build(:set_log, rpe: -1)).not_to be_valid
    expect(build(:set_log, rpe: 8.5)).to be_valid
  end

  describe "#estimated_one_rep_max" do
    it "computes the Epley estimated 1RM" do
      set = build(:set_log, weight: 100, reps: 10)
      expect(set.estimated_one_rep_max).to be_within(0.01).of(133.33)
    end
  end
end
