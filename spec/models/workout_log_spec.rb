require "rails_helper"

RSpec.describe WorkoutLog, type: :model do
  it "has a valid factory" do
    expect(build(:workout_log)).to be_valid
  end

  describe "#completed?" do
    it "is false without a completed_at, true with one" do
      expect(build(:workout_log, completed_at: nil).completed?).to be false
      expect(build(:workout_log, completed_at: Time.current).completed?).to be true
    end
  end

  describe "#duration" do
    it "is nil until completed" do
      log = build(:workout_log, completed_at: nil)
      expect(log.duration).to be_nil
    end

    it "is the gap between started_at and completed_at" do
      start = Time.zone.local(2026, 1, 1, 10, 0, 0)
      log = build(:workout_log, started_at: start, completed_at: start + 45.minutes)
      expect(log.duration).to eq(45.minutes)
    end
  end
end
