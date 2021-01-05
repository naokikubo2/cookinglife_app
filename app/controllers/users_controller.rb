class UsersController < ApplicationController
  def index
    @users = User.all
    @users_friend = current_user.friends
  end

  def show
    @user = User.find(params[:id])
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
