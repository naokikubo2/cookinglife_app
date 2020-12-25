class TagsController < ApplicationController
  def index
    @tags = FoodRecord.tag_counts_on(:tags).order('count DESC')
    if @tag = params[:tag]   # タグ検索用
      @food_records_others = FoodRecord.tagged_with(params[:tag]).where.not(user_id: current_user.id)
      @food_records_mine = current_user.food_record.tagged_with(params[:tag])   # タグに紐付く投稿
    end
  end
end
