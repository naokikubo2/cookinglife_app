module SpecSupport
  # Used when giving a unique name
  def timestamp!(timestamp = Time.now.to_i)
    @timestamp = timestamp
  end

  def timestamp
    @timestamp
  end

  def current_user
    @current_user
  end

  def log_in(user = create(:user))
    @current_user = user
    sign_in(user)
  end

  def log_out
    sign_out(current_user)
  end

  def json_response
    @json_response ||= JSON.parse(response.body)
  end

  def friend_user
    @friend_user
  end

  def make_friend
    @friend_user = create(:user)
    @current_user.follow(@friend_user.id)
    @friend_user.follow(@current_user.id)
  end
end
