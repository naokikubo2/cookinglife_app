module ApplicationHelper
  def follow_button(user)
    label, key = current_user.following?(user) ? %w[フォロー中 secondary] : %w[フォローする primary]
    link_to(label, user_follow_path(@user), method: :post, remote: true, class: "btn btn-#{key} rounded-pill")
  end
end
