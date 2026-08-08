class Exercise < ApplicationRecord
  has_many :workout_template_exercises, dependent: :destroy
  has_many :set_logs, dependent: :destroy

  enum :muscle_group, {
    chest: 0, back: 1, legs: 2, shoulders: 3, arms: 4, core: 5, full_body: 6
  }

  enum :equipment, {
    barbell: 0, dumbbell: 1, machine: 2, bodyweight: 3, cable: 4, kettlebell: 5
  }

  validates :name, presence: true, uniqueness: true
end
