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
end
