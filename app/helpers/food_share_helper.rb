module FoodShareHelper
  def time_format(time)
    l time, formats: :default if time.present?
  end

  def before_limit_time?(food_share)
    food_share.limit_time > Time.zone.now
  end
end
