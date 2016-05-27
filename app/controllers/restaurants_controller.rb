class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.restaurants.create(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render :new
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.belongs_to? current_user
      render :edit
    else
      flash[:notice] = "User can not edit another user's Restaurant"
      redirect_to restaurants_path
    end
  end

  def update
    restaurant = Restaurant.find(params[:id])
    restaurant.update(restaurant_params)
    redirect_to '/restaurants'
  end

  def destroy
    restaurant = Restaurant.find(params[:id])
    if restaurant.belongs_to? current_user
      restaurant.destroy
      flash[:notice] = "#{restaurant.name} no longer exists"
    else
      flash[:notice] = "User can not delete another user's Restaurant"
    end
      redirect_to restaurants_path
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :description)
  end

end
