class RegistrationsController < ApplicationController
  skip_before_action :require_authentication

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome to Vitality, #{@user.name}!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :name, :age, :biological_sex,
      :weight_kg, :height_cm, :activity_level, :goal
    )
  end
end
