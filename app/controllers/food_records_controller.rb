class FoodRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food_record, only: [:show, :edit, :update, :destroy]
  before_action :check_role, only: [:edit, :update, :destroy]

  def new
    @food_record = current_user.food_records.build
  end

  def create
    @food_record = current_user.food_records.build(food_record_params)
    @food_record.food_date = Time.zone.today

    open_weather = Api::OpenWeatherMap::Request.new(current_user.location_id)
    response = open_weather.request
    if @food_record.valid?
      if response['cod'] == 200
        params_weather = Api::OpenWeatherMap::Request.attributes_for(response)
        @food_record.update(params_weather)
        flash[:notice] = "登録に成功しました"
      else
        flash[:notice] = "天気情報の取得に失敗しましたが、登録に成功しました"
      end
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @tags = @food_record.tag_counts_on(:tags)
  end

  def index
    @search = current_user.food_records.ransack(params[:q])
    @food_records = @search.result(distinct: true)
    @tags = current_user.food_records.tag_counts_on(:tags)
    @food_records_followings = current_user.food_records_followings
  end

  def edit; end

  def update
    if food_records_params[:food_date].present? && (food_records_params[:food_date].to_date != @food_record.food_date.to_date)
      @food_record.assign_attributes(weather_main: "", weather_description: "", weather_icon: "", weather_id: "", temp: "", temp_max: "",
                                     temp_min: "", humidity: "", pressure: "")
    end

    if @food_record.update(food_records_params)
      flash[:notice] = "登録に成功しました"
      redirect_to food_record_path(@food_record)
    else
      flash[:error] = "登録に失敗しました"
      render 'edit'
    end
  end

  def destroy
    @food_record.destroy
    flash[:notice] = "削除に成功しました"
    redirect_to food_records_url
  end

  def favorite
    @food_record = FoodRecord.includes(:favorites).find(params[:food_record_id])
    @food_record.favorites?(current_user) ? @food_record.unlike(current_user.id) : @food_record.like(current_user.id)
    render :favorite
  end

  private

  def food_record_params
    params.fetch(:food_record, {}).permit(:image)
  end

  def set_food_record
    @food_record = FoodRecord.find(params[:id])
  end

  def check_role
    redirect_to root_url unless @food_record.user_id == current_user.id
  end

  def food_records_params
    params.require(:food_record).permit(:food_name, :healthy_score,
                                        :total_score, :workload_score, :food_timing, :memo, :tag_list, :food_date).merge({ user_id: current_user.id })
  end
end
