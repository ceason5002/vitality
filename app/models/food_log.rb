class FoodLog < ApplicationRecord
  belongs_to :user
  belongs_to :food

  enum :meal_type, { breakfast: 0, lunch: 1, dinner: 2, snack: 3 }

  validates :logged_at, presence: true
  validates :servings, numericality: { greater_than: 0 }
  validates :meal_type, presence: true

  scope :on_date, ->(date) { where(logged_at: date.beginning_of_day..date.end_of_day) }
  scope :between_dates, ->(start_date, end_date) { where(logged_at: start_date.beginning_of_day..end_date.end_of_day) }

  def total_calories
    food.calories * servings
  end

  def total_protein_g
    food.protein_g * servings
  end

  def total_carbs_g
    food.carbs_g * servings
  end

  def total_fat_g
    food.fat_g * servings
  end
end
