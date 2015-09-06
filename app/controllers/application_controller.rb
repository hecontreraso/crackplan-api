class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :null_session
  
  protected
    def set_locale
      I18n.locale = request.headers["Accept-Language"]
    end

    def authenticate
      authenticate_token || render_unauthorized
    end

    def authenticate_token
      authenticate_with_http_token do |token|
        @current_user = User.find_by(auth_token: token)
      end
    end

    def render_unauthorized
      render json: 'Bad credentials', status: 401
    end

    def time_ago(time)
      time_ago = Time.now - time

      minutes_ago = (time_ago / 60.minutes).round
      if minutes_ago < 60
        return "#{minutes_ago}m"
      else
        hours_ago = (time_ago / 1.hour).round
        if hours_ago < 24
          return "#{hours_ago}h"
        else
          days_ago = (time_ago / 1.day).round
          if days_ago < 7
            return "#{days_ago}d"
          else
            weeks_ago = (time_ago / 1.week).round
            return "#{weeks_ago}w"
          end
        end
      end
    end
end



