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
      flash[:notice] = "登録に成功しました"
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
