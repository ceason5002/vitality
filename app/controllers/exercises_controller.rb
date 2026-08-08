class ExercisesController < ApplicationController
  def index
    @muscle_group = params[:muscle_group]
    scope = @muscle_group.present? ? Exercise.where(muscle_group: @muscle_group) : Exercise.all
    @exercises = scope.order(:name)
  end

  def show
    @exercise = Exercise.find(params[:id])
    @recent_sets = SetLog.joins(:workout_log)
                          .where(exercise_id: @exercise.id, workout_logs: { user_id: current_user.id })
                          .order(created_at: :desc)
                          .limit(20)
  end
end
