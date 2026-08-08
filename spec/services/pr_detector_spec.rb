require "rails_helper"

RSpec.describe PrDetector do
  let(:user) { create(:user) }
  let(:exercise) { create(:exercise) }

  def log_set(user:, exercise:, weight:, reps:, started_at: Time.current)
    workout_log = create(:workout_log, user: user, started_at: started_at)
    create(:set_log, workout_log: workout_log, exercise: exercise, weight: weight, reps: reps)
  end

  it "is not a PR the first time an exercise is logged" do
    set = build(:set_log, workout_log: create(:workout_log, user: user), exercise: exercise, weight: 100, reps: 10)
    expect(PrDetector.new(set).pr?).to be false
  end

  it "is a PR when the estimated 1RM beats the prior best" do
    log_set(user: user, exercise: exercise, weight: 100, reps: 10, started_at: 2.days.ago) # e1RM 133.3

    new_set = build(:set_log, workout_log: create(:workout_log, user: user), exercise: exercise, weight: 120, reps: 10) # e1RM 160
    expect(PrDetector.new(new_set).pr?).to be true
  end

  it "is not a PR when the estimated 1RM is lower than or equal to the prior best" do
    log_set(user: user, exercise: exercise, weight: 120, reps: 10, started_at: 2.days.ago) # e1RM 160

    lower = build(:set_log, workout_log: create(:workout_log, user: user), exercise: exercise, weight: 100, reps: 10) # e1RM 133.3
    expect(PrDetector.new(lower).pr?).to be false
  end

  it "only compares against the same user's history for the same exercise" do
    other_user = create(:user)
    log_set(user: other_user, exercise: exercise, weight: 200, reps: 10, started_at: 2.days.ago)

    first_set_for_user = build(:set_log, workout_log: create(:workout_log, user: user), exercise: exercise, weight: 60, reps: 5)
    expect(PrDetector.new(first_set_for_user).pr?).to be false
  end

  it "excludes the set itself when checking an already-persisted set" do
    workout_log = create(:workout_log, user: user)
    set = create(:set_log, workout_log: workout_log, exercise: exercise, weight: 100, reps: 10)

    expect(PrDetector.new(set).pr?).to be false
  end
end
