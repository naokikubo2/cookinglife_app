class HomesController < ApplicationController
  def top
    if user_signed_in?


      @food_records = current_user.food_records.order(food_date: "DESC")
      @food_count = @food_records.count
      @tags = current_user.food_records.tag_counts_on(:tags)
      @food_records_followings = current_user.food_records_followings.order(food_date: "DESC")

      # 今日の料理レコメンドを受けとる
      recommend = FoodRecord.food_recommend(current_user)
      @food_recommend = recommend if recommend.present?

      # 天気情報を受け取る
      open_weather = Api::OpenWeatherMap::Request.new(current_user.location_id)
      response = open_weather.request
      @weather = Api::OpenWeatherMap::Request.attributes_for(response) if response['cod'] == 200

      # 気温が今日に近い日の料理を探す
      food_records_mine = current_user.food_records
      recommend_weather = weather_recommend(food_records_mine, @weather[:temp])
      @weather_recommend = recommend_weather if recommend_weather.present?

      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def weather_recommend(foods, temp)
    FoodRecord.weather_recommend(foods, temp) if foods.present?
  end
end
