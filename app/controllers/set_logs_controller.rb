class SetLogsController < ApplicationController
  def create
    @workout_log = current_user.workout_logs.find(params[:workout_log_id])
    @set_log = @workout_log.set_logs.new(set_log_params)
    @set_log.is_pr = PrDetector.new(@set_log).pr?

    if @set_log.save
      redirect_to workout_log_path(@workout_log), notice: @set_log.is_pr? ? "New PR!" : "Set logged."
    else
      redirect_to workout_log_path(@workout_log), alert: @set_log.errors.full_messages.to_sentence
    end
  end

  def update
    @set_log = SetLog.joins(:workout_log).where(workout_logs: { user_id: current_user.id }).find(params[:id])
    @workout_log = @set_log.workout_log
    @set_log.assign_attributes(set_log_params)
    @set_log.is_pr = PrDetector.new(@set_log).pr?

    if @set_log.save
      redirect_to workout_log_path(@workout_log), notice: "Set updated."
    else
      redirect_to workout_log_path(@workout_log), alert: @set_log.errors.full_messages.to_sentence
    end
  end

  private

  def set_log_params
    params.require(:set_log).permit(:exercise_id, :set_number, :weight, :reps, :rpe)
  end
end
