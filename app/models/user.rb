class User < ApplicationRecord
  has_secure_password

  has_many :food_logs, dependent: :destroy
  has_many :workout_templates, dependent: :destroy
  has_many :workout_logs, dependent: :destroy
  has_many :foods, foreign_key: :created_by_user_id, inverse_of: :created_by_user, dependent: :nullify

  enum :activity_level, {
    sedentary: 0,
    lightly_active: 1,
    moderately_active: 2,
    very_active: 3,
    extra_active: 4
  }, default: :sedentary

  enum :goal, { cut: 0, bulk: 1, maintain: 2 }, default: :maintain
  enum :biological_sex, { male: 0, female: 1 }

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                     format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :weight_kg, numericality: { greater_than: 0 }, allow_nil: true
  validates :height_cm, numericality: { greater_than: 0 }, allow_nil: true

  before_save { self.email = email.downcase if email.present? }

  def suggested_targets
    TdeeCalculator.new(self).targets
  end

  def daily_calorie_target_or_suggested
    daily_calorie_target || suggested_targets[:calories]
  end

  def daily_protein_target_g_or_suggested
    daily_protein_target_g || suggested_targets[:protein_g]
  end

  def daily_carbs_target_g_or_suggested
    daily_carbs_target_g || suggested_targets[:carbs_g]
  end

  def daily_fat_target_g_or_suggested
    daily_fat_target_g || suggested_targets[:fat_g]
  end
end
