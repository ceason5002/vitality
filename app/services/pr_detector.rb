# Flags a set as a personal record by comparing its estimated one-rep max
# (Epley formula: weight * (1 + reps/30)) against the user's best prior set
# for the same exercise. A first-ever set for an exercise is not flagged —
# there is no prior best to beat yet, but it becomes the baseline going forward.
class PrDetector
  def initialize(set_log)
    @set_log = set_log
  end

  def pr?
    best = best_previous_one_rep_max
    return false if best.nil?

    set_log.estimated_one_rep_max > best
  end

  private

  attr_reader :set_log

  def best_previous_one_rep_max
    scope = SetLog.joins(:workout_log)
                   .where(exercise_id: set_log.exercise_id, workout_logs: { user_id: set_log.workout_log.user_id })
    scope = scope.where.not(id: set_log.id) if set_log.persisted?

    scope.maximum(Arel.sql("weight * (1 + reps / 30.0)"))
  end
end
