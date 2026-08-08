class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path, notice: "Profile updated."
    else
      @user = current_user
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :age, :biological_sex, :weight_kg, :height_cm, :activity_level, :goal,
      :daily_calorie_target, :daily_protein_target_g, :daily_carbs_target_g, :daily_fat_target_g
    )
  end
end
