class FrCommentsController < ApplicationController
  before_action :set_food_record

  def create
    @comment = @food_record.fr_comments.new(fr_comment_params)
    if @comment.save
      #通知の作成
      @food_record.create_notification_comment!(current_user, @comment.id)
      render :remote_js
    end

  end

  def destroy
    @food_record.fr_comments.destroy(params[:id])
    render :remote_js
  end

  private

  def set_food_record
    @food_record = FoodRecord.find(params[:food_record_id])
  end

  def fr_comment_params
    params.require(:fr_comment).permit(:content).merge(user_id: current_user.id)
  end
end
