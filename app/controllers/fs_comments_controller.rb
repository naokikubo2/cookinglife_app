class FsCommentsController < ApplicationController
  before_action :set_food_share

  def create
    @food_share.fs_comments.new(fs_comment_params).save
    render :remote_js
  end

  def destroy
    @food_share.fs_comments.destroy(params[:id])
    render :remote_js
  end

  private

  def set_food_share
    @food_share = FoodShare.find(params[:food_share_id])
  end

  def fs_comment_params
    params.require(:fs_comment).permit(:content).merge(user_id: current_user.id)
  end
end
