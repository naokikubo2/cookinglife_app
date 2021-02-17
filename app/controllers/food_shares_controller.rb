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

  def show
    # 他ユーザのお裾分け料理を表示する場合、徒歩にかかる時間を表示
    if current_user.id != @food_share.user_id
      distance_matrix = Api::DistanceMatrix::Request.new(
        current_user.latitude, current_user.longitude, @food_share.latitude, @food_share.longitude
      )
      response = distance_matrix.request

      @output_distance = Api::DistanceMatrix::Request.attributes_for(response) if response['status'] == 'OK'
    end

    # どの期間に当たるかでフラグを立てる⇨フラグでviewを変える
    @flag_time = @food_share.time_judgment
  end

  def index
    # 自ユーザのお裾分け
    @mine_before, @mine_undone, @mine_done = FoodShare.mine_sorting(current_user)

    # 他ユーザのお裾分け
    # 相互フォロ中のユーザ(友達)のfood_shareを抽出
    food_share_friend = current_user.food_shares_friends
    @friend_before, @friend_undone, @friend_done = food_share_friend.friend_sorting(current_user)
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

  def matching
    @food_share = FoodShare.includes(:matchings).find(params[:food_share_id])
    @food_share.takes?(current_user) ? @food_share.untake(current_user.id) : @food_share.take(current_user.id)
    render :matching
  end

  def complete
    matching = Matching.find_by(food_share_id: params[:food_share_id], user_id: params[:user_id])
    if matching.present?
      matching.update(status: "complete")
      flash[:notice] = "お裾分けが完了しました。"
    else
      flash[:error] = "お裾分け完了操作に失敗しました"
    end
    redirect_to root_url
  end

  private

  def food_share_params
    params.require(:food_share).permit(:limit_number, :give_time, :limit_time,
                                       :food_record_id, :memo, :latitude, :longitude).merge({ user_id: current_user.id })
  end

  def set_food_share
    @food_share = FoodShare.find(params[:id])
  end

  def check_role
    redirect_to root_url unless @food_share.user_id == current_user.id
  end
end
