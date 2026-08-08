class WorkoutTemplate < ApplicationRecord
  belongs_to :user
  has_many :workout_template_exercises, -> { order(:position) }, dependent: :destroy, inverse_of: :workout_template
  has_many :exercises, through: :workout_template_exercises
  has_many :workout_logs, dependent: :nullify

  validates :name, presence: true

  accepts_nested_attributes_for :workout_template_exercises, allow_destroy: true, reject_if: :all_blank
end
