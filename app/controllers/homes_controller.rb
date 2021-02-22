class HomesController < ApplicationController
  def top
    @food_records = current_user.food_records
    @food_records_followings = current_user.food_records_followings

    # 今日の料理レコメンドを受けとる
    recommend = FoodRecord.food_recommend(current_user)
    @food_recommend = recommend if recommend.present?
  end
end
