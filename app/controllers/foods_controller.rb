class FoodsController < ApplicationController
  def index
    @query = params[:q]
    @foods = @query.present? ? Food.search(@query).order(:name).limit(30) : Food.order(:name).limit(30)
  end

  def new
    @food = Food.new(name: params[:name])
  end

  def create
    @food = Food.new(food_params)
    @food.source = :manual
    @food.created_by_user = current_user
    if @food.save
      redirect_to food_logs_path, notice: "Added #{@food.name}."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def food_params
    params.require(:food).permit(:name, :brand, :serving_size_qty, :serving_size_unit, :calories, :protein_g, :carbs_g, :fat_g)
  end
end
