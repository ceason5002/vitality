class WorkoutTemplateExercise < ApplicationRecord
  belongs_to :workout_template
  belongs_to :exercise

  validates :position, presence: true
  validates :target_sets, numericality: { only_integer: true, greater_than: 0 }
  validates :target_reps_min, numericality: { only_integer: true, greater_than: 0 }
  validates :target_reps_max, numericality: { only_integer: true, greater_than_or_equal_to: :target_reps_min }

  def target_reps_range
    target_reps_min..target_reps_max
  end
end
