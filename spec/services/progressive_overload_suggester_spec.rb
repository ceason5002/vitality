require "rails_helper"

RSpec.describe ProgressiveOverloadSuggester do
  let(:user) { create(:user) }
  let(:exercise) { create(:exercise) }
  let(:template) { create(:workout_template, user: user) }
  let!(:template_exercise) do
    create(:workout_template_exercise, workout_template: template, exercise: exercise,
                                        target_sets: 3, target_reps_min: 8, target_reps_max: 10)
  end

  def log_session(started_at:, reps_per_set:, weight: 100, template: nil, completed: true)
    log = create(:workout_log, user: user, workout_template: template, started_at: started_at,
                                completed_at: completed ? started_at + 45.minutes : nil)
    reps_per_set.each_with_index do |reps, i|
      create(:set_log, workout_log: log, exercise: exercise, set_number: i + 1, weight: weight, reps: reps)
    end
    log
  end

  it "returns no suggestions for a freestyle workout with no template" do
    log = log_session(started_at: Time.current, reps_per_set: [10, 10, 10], template: nil)
    expect(described_class.new(log).suggestions).to eq([])
  end

  it "returns no suggestions for an exercise that isn't part of the template" do
    other_exercise = create(:exercise, name: "Untracked Exercise")
    log = create(:workout_log, user: user, workout_template: template, started_at: Time.current, completed_at: Time.current)
    create(:set_log, workout_log: log, exercise: other_exercise, set_number: 1, weight: 50, reps: 10)

    expect(described_class.new(log).suggestions).to eq([])
  end

  it "returns no suggestion when reps are within the target range (neither hitting the top nor missing the bottom)" do
    log = log_session(started_at: Time.current, reps_per_set: [9, 9, 9], template: template)
    expect(described_class.new(log).suggestions).to eq([])
  end

  describe "weight increase suggestion" do
    it "suggests a weight increase when every set hits the top of the target rep range" do
      log = log_session(started_at: Time.current, reps_per_set: [10, 10, 10], template: template)

      suggestions = described_class.new(log).suggestions
      expect(suggestions.size).to eq(1)
      expect(suggestions.first.exercise).to eq(exercise)
      expect(suggestions.first.action).to eq(:increase_weight)
    end

    it "suggests a weight increase when sets exceed the top of the range" do
      log = log_session(started_at: Time.current, reps_per_set: [12, 11, 10], template: template)
      expect(described_class.new(log).suggestions.first.action).to eq(:increase_weight)
    end

    it "does not suggest an increase if even one set falls short of the top of the range" do
      log = log_session(started_at: Time.current, reps_per_set: [10, 10, 9], template: template)
      expect(described_class.new(log).suggestions).to eq([])
    end
  end

  describe "deload/hold suggestion" do
    it "does not suggest a deload after only one below-target session" do
      log = log_session(started_at: Time.current, reps_per_set: [5, 5, 5], template: template)
      expect(described_class.new(log).suggestions).to eq([])
    end

    it "suggests a deload after two consecutive below-target sessions" do
      log_session(started_at: 2.days.ago, reps_per_set: [5, 5, 5], template: template)
      current = log_session(started_at: Time.current, reps_per_set: [5, 5, 5], template: template)

      suggestions = described_class.new(current).suggestions
      expect(suggestions.size).to eq(1)
      expect(suggestions.first.action).to eq(:deload_or_hold)
    end

    it "does not suggest a deload if the shortfall streak was broken by a good session" do
      log_session(started_at: 3.days.ago, reps_per_set: [5, 5, 5], template: template)
      log_session(started_at: 2.days.ago, reps_per_set: [9, 9, 9], template: template)
      current = log_session(started_at: Time.current, reps_per_set: [5, 5, 5], template: template)

      expect(described_class.new(current).suggestions).to eq([])
    end

    it "does not count a session as a shortfall unless ALL sets missed the bottom of the range" do
      log_session(started_at: 2.days.ago, reps_per_set: [5, 9, 5], template: template) # mixed, not a full shortfall
      current = log_session(started_at: Time.current, reps_per_set: [5, 5, 5], template: template)

      expect(described_class.new(current).suggestions).to eq([])
    end
  end
end
