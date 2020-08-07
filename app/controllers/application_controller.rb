class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  # after_action :check_flash_message

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :mobile, :admin])
  end

  def check_flash_message
    return unless request.xhr? && request.format.js?
    response.body += "flash_alert('#{view_context.j flash.now[:alert]}');" if flash.now[:alert].present?
    response.body += "flash_notice('#{view_context.j flash.now[:notice]}');" if flash.now[:notice].present?
  end

end
