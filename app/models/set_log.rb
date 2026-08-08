class SetLog < ApplicationRecord
  belongs_to :workout_log
  belongs_to :exercise

  validates :set_number, numericality: { only_integer: true, greater_than: 0 }
  validates :weight, numericality: { greater_than_or_equal_to: 0 }
  validates :reps, numericality: { only_integer: true, greater_than: 0 }
  validates :rpe, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }, allow_nil: true

  delegate :user, to: :workout_log

  def estimated_one_rep_max
    weight * (1 + reps / 30.0)
  end
end
