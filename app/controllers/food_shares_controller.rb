class FoodSharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food_share, only: [:show, :edit, :update, :destroy]
  before_action :check_role, only: [:edit, :update, :destroy]

  def new
    @food_share = current_user.food_shares.build
  end

  def create
    @food_share = current_user.food_shares.build(food_share_params)
    @food_record = FoodRecord.find(food_share_params[:food_record_id])
    @food_share.food_name = @food_record.food_name
    @food_share.image = @food_record.image
    if @food_share.save
      flash[:notice] = "登録に成功しました"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show; end

  def index
    @food_shares = current_user.food_shares
    @food_shares_friends = current_user.food_shares_friends
  end

  def edit; end

  def update
    if @food_share.update(food_share_params)
      flash[:notice] = "登録に成功しました"
      redirect_to food_share_path(@food_share)
    else
      flash[:error] = "登録に失敗しました"
      render 'edit'
    end
  end

  def destroy
    @food_share.destroy
    flash[:notice] = "削除に成功しました"
    redirect_to food_shares_url
  end

  private

  def food_share_params
    params.require(:food_share).permit(:limit_number, :give_time, :limit_time,
                                       :food_record_id, :memo).merge({ user_id: current_user.id })
  end

  def set_food_share
    @food_share = FoodShare.find(params[:id])
  end

  def check_role
    redirect_to root_url unless @food_share.user_id == current_user.id
  end
end
