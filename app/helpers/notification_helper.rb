module NotificationHelper
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end

  def notification_form(notification)
    @visiter = notification.visiter
    @comment = nil
    #notification.actionがfollowかlikeかcommentか
    case notification.action
      when "follow" then
        tag.a(notification.visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"があなたをフォロー"
      when "like" then
        tag.a(notification.visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:food_record_path(notification.food_record_id), style:"font-weight: bold;")+"にいいね"
      when "comment" then
        @visiter_comment = notification.fr_comment_id
        @comment = FrComment.find_by(id: @visiter_comment).content
        tag.a(@visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:food_record_path(notification.food_record_id), style:"font-weight: bold;")+"にコメント"
    end
  end
end
