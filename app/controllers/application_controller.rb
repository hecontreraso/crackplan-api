class ApplicationController < ActionController::API
	protect_from_forgery with: :null_session
  before_action :set_locale
  
  protected
  def set_locale
    I18n.locale = request.headers["Accept-Language"]
  end
end
