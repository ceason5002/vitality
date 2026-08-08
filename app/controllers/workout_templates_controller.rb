class WorkoutTemplatesController < ApplicationController
  before_action :set_workout_template, only: %i[show edit update destroy]

  def index
    @workout_templates = current_user.workout_templates.order(:name)
  end

  def show
  end

  def new
    @workout_template = current_user.workout_templates.new
    5.times { @workout_template.workout_template_exercises.build }
  end

  def create
    @workout_template = current_user.workout_templates.new(workout_template_params)
    if @workout_template.save
      redirect_to workout_templates_path, notice: "Created #{@workout_template.name}."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    3.times { @workout_template.workout_template_exercises.build }
  end

  def update
    if @workout_template.update(workout_template_params)
      redirect_to workout_templates_path, notice: "Updated #{@workout_template.name}."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @workout_template.destroy
    redirect_to workout_templates_path, notice: "Deleted."
  end

  private

  def set_workout_template
    @workout_template = current_user.workout_templates.find(params[:id])
  end

  def workout_template_params
    permitted = params.require(:workout_template).permit(
      :name, :description,
      workout_template_exercises_attributes: %i[id exercise_id target_sets target_reps_min target_reps_max _destroy]
    )

    next_position = 1
    permitted[:workout_template_exercises_attributes]&.each_value do |attrs|
      if attrs[:exercise_id].present?
        attrs[:position] = next_position
        next_position += 1
      end
    end

    permitted
  end
end
