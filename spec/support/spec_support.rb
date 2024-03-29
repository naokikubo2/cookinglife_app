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

  def log_in(user = create(:user), type: :request)
    @current_user = user
    case type
    when :request
      sign_in(user)
    when :system
      visit new_user_session_path
      find("#user_email").set(user.email)
      find("#user_password").set(user.password)
      first("input[value='ログイン']").click
    end
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

  # give me block return boolean
  def wait_until(wait_time = Capybara.default_max_wait_time)
    Timeout.timeout(wait_time) do
      loop until yield
    end
  end

  def set_geocoder
    Geocoder.configure(lookup: :test)
    Geocoder::Lookup::Test.add_stub(
      '東京都港区', [{
        'coordinates' => [35.7090259, 139.7319925]
      }]
    )
    Geocoder::Lookup::Test.add_stub(
      'ダメなキーワード', []
    )
  end

  def set_response
    # モックサーバーからのレスポンスのjsonファイルを読み込み
    external_api_response = ActiveSupport::JSON.decode(File.read("spec/fixtures/weather.json")).to_json
    stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?appid=testkey&id=1850147&units=metric").to_return(
      body: external_api_response,
      status: 200
    )
  end

  def set_error_response
    # モックサーバーからのレスポンスのjsonファイルを読み込み
    external_api_response = ActiveSupport::JSON.decode(File.read("spec/fixtures/weather_error.json")).to_json
    stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?appid=testkey&id=1850147&units=metric").to_return(
      body: external_api_response,
      status: 404
    )
  end

  def set_distance_response
    # モックサーバーからのレスポンスのjsonファイルを読み込み
    external_api_response = ActiveSupport::JSON.decode(File.read("spec/fixtures/distance_matrix/distance_matrix.json")).to_json
    stub_request(:get, "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=35.709,139.732&key=testkey&language=ja-JA&mode=walking&origins=35.7090259,139.7319925").to_return(
      body: external_api_response,
      status: 200
    )
  end
end
