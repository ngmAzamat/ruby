class ApplicationController < ActionController::Base
    helper_method :current_user

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
    before_action :set_theme

    private

    def set_theme
      @theme = cookies[:theme] || "light"  # по умолчанию "light"
    end
end