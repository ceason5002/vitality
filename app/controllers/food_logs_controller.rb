class FoodLogsController < ApplicationController
  def index
    @date = parse_date(params[:date]) || Date.current
    @food_logs = current_user.food_logs.on_date(@date).includes(:food).order(:logged_at)
    @grouped = @food_logs.group_by(&:meal_type)
    @totals = {
      calories: @food_logs.sum(&:total_calories),
      protein_g: @food_logs.sum(&:total_protein_g),
      carbs_g: @food_logs.sum(&:total_carbs_g),
      fat_g: @food_logs.sum(&:total_fat_g)
    }
    @targets = {
      calories: current_user.daily_calorie_target_or_suggested,
      protein_g: current_user.daily_protein_target_g_or_suggested,
      carbs_g: current_user.daily_carbs_target_g_or_suggested,
      fat_g: current_user.daily_fat_target_g_or_suggested
    }
    @query = params[:q]
    @search_results = @query.present? ? Food.search(@query).order(:name).limit(15) : Food.none
  end

  def new
    @food_log = current_user.food_logs.new(logged_at: Time.current, meal_type: params[:meal_type])
  end

  def create
    @food_log = current_user.food_logs.new(food_log_params)
    @food_log.logged_at = Time.current if @food_log.logged_at.blank?
    if @food_log.save
      redirect_to food_logs_path(date: @food_log.logged_at.to_date), notice: "Logged #{@food_log.food.name}."
    else
      redirect_to food_logs_path, alert: @food_log.errors.full_messages.to_sentence
    end
  end

  def destroy
    @food_log = current_user.food_logs.find(params[:id])
    date = @food_log.logged_at.to_date
    @food_log.destroy
    redirect_to food_logs_path(date: date), notice: "Removed."
  end

  private

  def parse_date(value)
    Date.parse(value) if value.present?
  rescue Date::Error, ArgumentError
    nil
  end

  def food_log_params
    params.require(:food_log).permit(:food_id, :servings, :meal_type, :logged_at)
  end
end
