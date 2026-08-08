require "rails_helper"

RSpec.describe WorkoutTemplateExercise, type: :model do
  it "has a valid factory" do
    expect(build(:workout_template_exercise)).to be_valid
  end

  it "requires target_reps_max to be at least target_reps_min" do
    invalid = build(:workout_template_exercise, target_reps_min: 10, target_reps_max: 8)
    valid = build(:workout_template_exercise, target_reps_min: 8, target_reps_max: 10)

    expect(invalid).not_to be_valid
    expect(valid).to be_valid
  end

  it "requires positive target_sets" do
    expect(build(:workout_template_exercise, target_sets: 0)).not_to be_valid
  end
end
