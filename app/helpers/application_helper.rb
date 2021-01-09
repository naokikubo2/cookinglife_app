module ApplicationHelper
  def follow_button(user)
    label, key = current_user.following?(user) ? %w[フォロー中 secondary] : %w[フォローする primary]
    link_to(label, user_follow_path(@user), method: :post, remote: true, class: "btn btn-#{key} rounded-pill")
  end

  def take_button(user, food_share)
    if food_share.takes?(user) || food_share.limit_number > @food_share.matchings.count
      label = food_share.takes?(user) ? "申請済み" : "お裾分け希望する"
      link_to(label, food_share_matching_path(food_share), method: :post, remote: true)
    else
      '募集人数上限に達しました'
    end
  end
end
