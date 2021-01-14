class FrCommentsController < ApplicationController
  before_action :set_food_record

  def create
    @food_record.fr_comments.new(fr_comment_params).save
    render :remote_js
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
