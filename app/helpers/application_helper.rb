module ApplicationHelper
  def follow_button(user)
    label, key = current_user.following?(user) ? %w[フォロー中 secondary] : %w[フォローする primary]
    link_to(label, user_follow_path(@user), method: :post, remote: true, class: "btn btn-#{key} rounded-pill")
  end

  def take_button(user, food_share)
    if food_share.takes?(user) || food_share.limit_number > @food_share.matchings.count
      label, key = food_share.takes?(user) ? %w[申請済み secondary] : %w[お裾分けを希望する primary]
      link_to(label, food_share_matching_path(food_share), method: :post, remote: true, class: "btn btn-#{key} rounded-pill")
    else
      '募集人数上限に達しました'
    end
  end

  def heart_icon(food_record)
    suffix = food_record.favorites?(current_user) ? "s" : "r"
    tag.i("", class: "fa#{suffix} fa-heart")
  end

  def date_format(date)
    l date, format: :default if date.present?
  end

  def day_format(date)
    date.strftime("%a") if date.present?
  end
end
