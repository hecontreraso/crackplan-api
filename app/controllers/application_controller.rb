class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::RequestForgeryProtection

	protect_from_forgery with: :null_session
  
  before_action :set_locale

  protected
    def user_signed_in?
      !@current_user.nil?
    end

	  def set_locale
	    I18n.locale = request.headers["Accept-Language"]
	  end

    def authenticate(optional = false)
      if optional
        authenticate_token
      else
        authenticate_token || render_unauthorized
      end
    end

    def authenticate_token
      authenticate_with_http_token do |token|
        @current_user = User.find_by(auth_token: token)
      end
    end

    def render_unauthorized
			render json: 'Bad credentials', status: 401
    end
end
