class WorkoutLog < ApplicationRecord
  belongs_to :user
  belongs_to :workout_template, optional: true
  has_many :set_logs, dependent: :destroy

  validates :started_at, presence: true

  def completed?
    completed_at.present?
  end

  def duration
    return nil unless completed_at

    completed_at - started_at
  end
end
