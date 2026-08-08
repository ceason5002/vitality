# Suggested daily calorie/macro targets from the Mifflin-St Jeor equation.
#
# Mifflin-St Jeor needs biological sex; when a user hasn't set it we fall back
# to the midpoint of the male (+5) and female (-161) offset constants.
class TdeeCalculator
  ACTIVITY_MULTIPLIERS = {
    "sedentary" => 1.2,
    "lightly_active" => 1.375,
    "moderately_active" => 1.55,
    "very_active" => 1.725,
    "extra_active" => 1.9
  }.freeze

  GOAL_CALORIE_ADJUSTMENT = {
    "cut" => -500,
    "bulk" => 300,
    "maintain" => 0
  }.freeze

  GOAL_PROTEIN_G_PER_KG = {
    "cut" => 2.2,
    "bulk" => 1.8,
    "maintain" => 2.0
  }.freeze

  FAT_PERCENT_OF_CALORIES = 0.25

  def initialize(user)
    @user = user
  end

  def bmr
    return nil unless user.weight_kg && user.height_cm && user.age

    base = (10 * user.weight_kg.to_f) + (6.25 * user.height_cm.to_f) - (5 * user.age)
    base + sex_offset
  end

  def tdee
    return nil unless bmr

    bmr * ACTIVITY_MULTIPLIERS.fetch(user.activity_level, 1.2)
  end

  def targets
    return empty_targets unless tdee

    calories = tdee + GOAL_CALORIE_ADJUSTMENT.fetch(user.goal, 0)
    protein_g = GOAL_PROTEIN_G_PER_KG.fetch(user.goal, 2.0) * user.weight_kg.to_f
    fat_g = (calories * FAT_PERCENT_OF_CALORIES) / 9.0
    remaining_calories = calories - (protein_g * 4) - (fat_g * 9)
    carbs_g = [remaining_calories, 0].max / 4.0

    {
      calories: calories.round,
      protein_g: protein_g.round(1),
      carbs_g: carbs_g.round(1),
      fat_g: fat_g.round(1)
    }
  end

  private

  attr_reader :user

  def sex_offset
    case user.biological_sex
    when "male" then 5
    when "female" then -161
    else -78 # midpoint fallback when sex isn't set
    end
  end

  def empty_targets
    { calories: nil, protein_g: nil, carbs_g: nil, fat_g: nil }
  end
end
