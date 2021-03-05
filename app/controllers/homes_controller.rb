class HomesController < ApplicationController
  def top
    if user_signed_in?
      @food_records = current_user.food_records.order(food_date: "DESC")

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
end
