class HomesController < ApplicationController
  def top
    @food_records = current_user.food_records
    @food_records_followings = current_user.food_records_followings

    # 今日の料理レコメンドを受けとる
    recommend = FoodRecord.food_recommend(current_user)
    @food_recommend = recommend if recommend.present?

    # 天気情報を受け取る
    open_weather = Api::OpenWeatherMap::Request.new(current_user.location_id)
    response = open_weather.request
    if response['cod'] == 200
      @weather = Api::OpenWeatherMap::Request.attributes_for(response)
    end
  end
end
