require "rails_helper"

RSpec.describe Exercise, type: :model do
  it "has a valid factory" do
    expect(build(:exercise)).to be_valid
  end

  it "requires a unique name" do
    create(:exercise, name: "Barbell Squat")
    expect(build(:exercise, name: "Barbell Squat")).not_to be_valid
  end

  it "exposes the expected muscle groups and equipment types" do
    expect(Exercise.muscle_groups.keys).to include("chest", "back", "legs", "shoulders", "arms", "core", "full_body")
    expect(Exercise.equipment.keys).to include("barbell", "dumbbell", "machine", "bodyweight", "cable", "kettlebell")
  end
end
