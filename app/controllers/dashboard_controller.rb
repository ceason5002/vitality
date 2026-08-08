class DashboardController < ApplicationController
  def show
    @date = parse_date(params[:date]) || Date.current
    @food_logs = current_user.food_logs.on_date(@date).includes(:food).order(:logged_at)
    @totals = daily_totals(@food_logs)
    @targets = {
      calories: current_user.daily_calorie_target_or_suggested,
      protein_g: current_user.daily_protein_target_g_or_suggested,
      carbs_g: current_user.daily_carbs_target_g_or_suggested,
      fat_g: current_user.daily_fat_target_g_or_suggested
    }
    @weekly_trend = weekly_trend
  end

  private

  def parse_date(value)
    Date.parse(value) if value.present?
  rescue Date::Error, ArgumentError
    nil
  end

  def daily_totals(logs)
    {
      calories: logs.sum(&:total_calories),
      protein_g: logs.sum(&:total_protein_g),
      carbs_g: logs.sum(&:total_carbs_g),
      fat_g: logs.sum(&:total_fat_g)
    }
  end

  def weekly_trend
    start_date = 6.days.ago.to_date
    logs = current_user.food_logs.between_dates(start_date, Date.current).includes(:food)
    logs_by_date = logs.group_by { |l| l.logged_at.to_date }

    (start_date..Date.current).map do |date|
      day_logs = logs_by_date[date] || []
      {
        date: date,
        calories: day_logs.sum(&:total_calories),
        protein_g: day_logs.sum(&:total_protein_g),
        carbs_g: day_logs.sum(&:total_carbs_g),
        fat_g: day_logs.sum(&:total_fat_g)
      }
    end
  end
end
