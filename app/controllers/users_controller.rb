class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @users = User.all
    @users_friend = current_user.friends
  end

  def followers
    user = User.find(params[:id])
    @followers = user.followers
  end

  def followings
    user = User.find(params[:id])
    @followings = user.followings
  end

  def show
    @user = User.find(params[:id])
    @food_records = @user.food_records.order(food_date: "DESC")
  end

  def follow
    other_user_id = params[:user_id]
    @user = User.find(other_user_id)
    if current_user.following?(@user)
      current_user.unfollow(other_user_id)
    else
      current_user.follow(other_user_id)
    end
    render :follow
  end
end
