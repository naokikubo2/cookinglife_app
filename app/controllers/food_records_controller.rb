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

    if @food_record.save
      open_weather = Api::OpenWeatherMap::Request.new(current_user.location_id)
      response = open_weather.request
      if response['cod'] == 200
        params_weather = Api::OpenWeatherMap::Request.attributes_for(response)
        @food_record.update(params_weather)
        flash[:notice] = "登録に成功しました"
      else
        flash[:notice] = "天気情報の取得に失敗しましたが、登録に成功しました"
      end
      redirect_to food_record_path(@food_record)
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

    # 今日の料理レコメンドを受けとる
    food_recommend
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

  def check_cache_image
    require "google/cloud/vision"

    # Vision APIの設定
    image_annotator = set_vision

    # キャッシュ情報を取得する
    image = params[:image_cache].path
    # キャッシュをVision APIにレスポンスとして渡す。
    response = image_annotator.label_detection image: image

    # labelを配列に入れる
    label_list = []
    label_list = get_list(response)

    # 1.食べ物の写真かを判定する
    @image_flag = %w[food dish cuisine].any? { |i| label_list.include?(i) }

    @tag_list = []
    array = [%w[cake ケーキ], %w[rice 米], %w[fish 魚], %w[soup スープ], %w[noodle 麺], %w[meat 肉], %w[fruit フルーツ], %w[sweetness スイーツ], %w[curry カレー],
             %w[bread パン]]
    array.each do |food|
      label_list.each do |label|
        @tag_list.push(food[1]) if label.include?(food[0])
      end
    end

    # jBuilderに送る準備
    @data = { tag_list: @tag_list, image_flag: @image_flag }

    respond_to do |format|
      format.html
      format.json
    end
  end

  private

  def food_record_params
    params.fetch(:food_record, {}).permit(:image, :tag_list)
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

  def set_vision
    Google::Cloud::Vision.image_annotator do |config|
      config.credentials = ENV["GOOGLE_APPLICATION_CREDENTIALS"]
    end
  end

  def get_list(response)
    list = []
    response.responses.each do |res|
      res.label_annotations.each do |label|
        list.push(label.description.downcase)
      end
    end
    list
  end

  def food_recommend
    # ログインユーザの料理
    food_records_mine = current_user.food_records
    # ログインユーザの昨日の料理
    food_record_yesterday = food_records_mine.where(food_date: Time.zone.today - 1)
    # ログインユーザの直近1週間の料理
    food_record_week = food_records_mine.where(food_date: Time.zone.today - 7..Time.zone.today - 1)

    # 今日〜1週間のデータを除く
    food_record_past = food_records_mine.where(food_date: ..Time.zone.today - 7)

    # 前日の料理、麺かどうか判定
    flag_noodle = false
    food_record_yesterday.each do |food|
      next if food.tags.nil?

      food.tags.each do |var|
        flag_noodle = true if var.name.include?("麺")
      end
    end
    # 麺料理がある場合は麺料理を除外
    food_record_past = food_record_past.tagged_with("麺", exclude: true) if flag_noodle

    # 直近1週間の料理名と一致するレコードを除外
    array_foodname = food_record_week.pluck(:food_name)
    food_record_past = food_record_past.where.not("food_name IN (?)", array_foodname)

    # 料理の類似度を分析
    y_food = food_record_yesterday.pluck(:workload_score, :healthy_score)
    p_food = food_record_past.pluck(:workload_score, :healthy_score, :id)
    max_distance = 0
    max_id = 0
    p_food.each do |p|
      next unless max_distance < (p[0] - y_food[0][0])**2 + (p[1] - y_food[0][1])**2

      max_distance = (p[0] - y_food[0][0])**2 + (p[1] - y_food[0][1])**2
      max_id = p[2]
    end
    @food_recommend = FoodRecord.find_by(id: max_id)
  end
end
