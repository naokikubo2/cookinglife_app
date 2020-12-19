class FoodRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food_record, only: [:show, :edit, :update, :destroy]
  before_action :check_role, only: [:show, :edit, :update, :destroy]

  def new
    @food_record = current_user.food_record.build
  end

  def create
    @food_record = current_user.food_record.build(food_record_params)
    if @food_record.save
        flash[:notice] = "料理画像のアップロードに成功しました"
        redirect_to root_url
    else
        flash[:error] = "料理画像のアップロードに失敗しました"
        render 'new'
    end
  end

  def show
  end

  def index
    @food_records = current_user.food_record
  end

  def edit
  end

  def update
    if @food_record.update(food_records_params)
      flash[:notice] = "登録に成功しました"
      redirect_to root_url
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
    params.require(:food_record).permit(:food_name, :healthy_score, :total_score, :workload_score, :food_timing, :memo).merge({ user_id: current_user.id })
  end

end