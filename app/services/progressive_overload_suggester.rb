# Compares a just-completed workout against the workout template's target rep
# ranges and the user's session history for the same exercises, and produces
# plain-language suggestions. Never mutates data - these are surfaced as a
# banner for the user to act on manually.
class ProgressiveOverloadSuggester
  WEIGHT_INCREASE_MIN = 0.025
  WEIGHT_INCREASE_MAX = 0.05
  SHORTFALL_SESSION_THRESHOLD = 2

  Suggestion = Struct.new(:exercise, :action, :message, keyword_init: true)

  def initialize(workout_log)
    @workout_log = workout_log
  end

  def suggestions
    return [] unless workout_log.workout_template

    exercises_in_workout.filter_map { |exercise| suggestion_for(exercise) }
  end

  private

  attr_reader :workout_log

  def exercises_in_workout
    Exercise.where(id: workout_log.set_logs.select(:exercise_id).distinct)
  end

  def suggestion_for(exercise)
    target = target_for(exercise)
    return nil unless target

    current_sets = workout_log.set_logs.where(exercise_id: exercise.id).to_a
    return nil if current_sets.empty?

    if current_sets.all? { |s| s.reps >= target.target_reps_max }
      increase_suggestion(exercise, current_sets, target)
    elsif shortfall_for_consecutive_sessions?(exercise, target, current_sets)
      deload_suggestion(exercise)
    end
  end

  def increase_suggestion(exercise, current_sets, target)
    top_weight = current_sets.map(&:weight).max
    low = (top_weight * (1 + WEIGHT_INCREASE_MIN)).round(1)
    high = (top_weight * (1 + WEIGHT_INCREASE_MAX)).round(1)

    Suggestion.new(
      exercise: exercise,
      action: :increase_weight,
      message: "All sets hit the top of your target range (#{target.target_reps_max} reps). " \
                "Try #{low}-#{high} next session (a #{(WEIGHT_INCREASE_MIN * 100).round}-#{(WEIGHT_INCREASE_MAX * 100).round}% increase)."
    )
  end

  def deload_suggestion(exercise)
    Suggestion.new(
      exercise: exercise,
      action: :deload_or_hold,
      message: "Reps have come in below target for #{SHORTFALL_SESSION_THRESHOLD}+ sessions in a row. " \
                "Consider a deload or holding at the current weight next time."
    )
  end

  def target_for(exercise)
    workout_log.workout_template.workout_template_exercises.find_by(exercise_id: exercise.id)
  end

  def shortfall_for_consecutive_sessions?(exercise, target, current_sets)
    sessions = [current_sets] + previous_sessions(exercise, limit: SHORTFALL_SESSION_THRESHOLD - 1)
    return false if sessions.size < SHORTFALL_SESSION_THRESHOLD

    sessions.first(SHORTFALL_SESSION_THRESHOLD).all? do |sets|
      sets.any? && sets.all? { |s| s.reps < target.target_reps_min }
    end
  end

  def previous_sessions(exercise, limit:)
    prior_logs = WorkoutLog.where(user_id: workout_log.user_id)
                            .where.not(id: workout_log.id)
                            .where("started_at < ?", workout_log.started_at)
                            .joins(:set_logs).where(set_logs: { exercise_id: exercise.id })
                            .distinct
                            .order(started_at: :desc)
                            .limit(limit)

    prior_logs.map { |log| log.set_logs.where(exercise_id: exercise.id).to_a }
  end
end
