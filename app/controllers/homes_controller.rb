class HomesController < ApplicationController
  def top
    if user_signed_in?
      fr = current_user.food_records.order(food_date: "DESC")
      @food_count = fr.count
      @food_records = fr.page(params[:foods_page]).per(24)

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
    if foods.present?
      FoodRecord.weather_recommend(foods, temp)
    else
      null
    end
  end
end
