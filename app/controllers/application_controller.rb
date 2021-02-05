class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :location_id, :latitude, :longitude, :address])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :location_id, :latitude, :longitude, :address])
  end
end
