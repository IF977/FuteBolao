class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authenticate_user!, :side_menu
  before_filter :configure_devise_params, if: :devise_controller?

  protect_from_forgery with: :exception

  def side_menu
    @users = User.rank.decorate
    @today_matches = Match.today.decorate
  end

  # needed to accept the user name
  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
  end
end
