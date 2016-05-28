class ReviewsController < ApplicationController

  before_action :authenticate_user!


  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.build_with_user review_params, current_user
    @review.save ? redirect_to(restaurants_path) : render(:new)
  end

  def review_params

    params.require(:review).permit(:thoughts, :rating)
  end

end
