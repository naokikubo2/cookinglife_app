module FoodShareHelper
  def time_format(time)
    l time, formats: :default if time.present?
  end
end
