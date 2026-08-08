require "rails_helper"

RSpec.describe WorkoutTemplate, type: :model do
  it "has a valid factory" do
    expect(build(:workout_template)).to be_valid
  end

  it "requires a name" do
    expect(build(:workout_template, name: nil)).not_to be_valid
  end

  it "rejects nested exercise rows that are entirely blank" do
    template = build(:workout_template)
    template.workout_template_exercises_attributes = [
      { exercise_id: create(:exercise).id, position: 1, target_sets: 3, target_reps_min: 8, target_reps_max: 10 },
      { exercise_id: nil, position: nil, target_sets: nil, target_reps_min: nil, target_reps_max: nil }
    ]

    template.save!
    expect(template.workout_template_exercises.count).to eq(1)
  end

  it "destroys dependent workout_template_exercises when destroyed" do
    template = create(:workout_template)
    create(:workout_template_exercise, workout_template: template)

    expect { template.destroy }.to change(WorkoutTemplateExercise, :count).by(-1)
  end
end
