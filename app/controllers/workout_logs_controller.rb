class WorkoutLogsController < ApplicationController
  before_action :set_workout_log, only: %i[show update]

  def index
    @workout_logs = current_user.workout_logs.includes(:workout_template).order(started_at: :desc)
  end

  def new
    @workout_templates = current_user.workout_templates.order(:name)
  end

  def create
    @workout_log = current_user.workout_logs.new(
      started_at: Time.current,
      workout_template_id: params[:workout_template_id].presence
    )
    if @workout_log.save
      redirect_to workout_log_path(@workout_log)
    else
      redirect_to workout_templates_path, alert: "Couldn't start workout."
    end
  end

  def show
    @template_exercises = @workout_log.workout_template&.workout_template_exercises&.order(:position)&.to_a || []
    @exercises = @template_exercises.any? ? @template_exercises.map(&:exercise) : Exercise.where(id: @workout_log.set_logs.select(:exercise_id).distinct)
    @set_logs_by_exercise = @workout_log.set_logs.group_by(&:exercise_id)
    @previous_sets_by_exercise = @exercises.index_with { |exercise| previous_sets_for(exercise.id) }
    @suggestions = @workout_log.completed? ? ProgressiveOverloadSuggester.new(@workout_log).suggestions : []
  end

  def update
    if params[:complete].present? && @workout_log.completed_at.blank?
      @workout_log.update(completed_at: Time.current)
    end
    redirect_to workout_log_path(@workout_log)
  end

  private

  def set_workout_log
    @workout_log = current_user.workout_logs.find(params[:id])
  end

  def previous_sets_for(exercise_id)
    prior_log = WorkoutLog.where(user_id: current_user.id)
                           .where.not(id: @workout_log.id)
                           .where("started_at < ?", @workout_log.started_at)
                           .joins(:set_logs).where(set_logs: { exercise_id: exercise_id })
                           .order(started_at: :desc)
                           .first
    return [] unless prior_log

    prior_log.set_logs.where(exercise_id: exercise_id).order(:set_number).to_a
  end
end
