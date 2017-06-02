class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :ensure_sign_in

  def sign_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id)
    elsif user_id = cookies.signed[:user_id]
      user = User.find(user_id)
      if user && user.cookies_auth_user(cookies[:remember_token])
        sign_in user
      end
    end
  end

  def sign_in?
    !!current_user
  end

  def sign_out
    forget_me(current_user)
    session[:user_id] = nil
  end

  def after_sign_in_path
    if current_user.admin?
      admin_users_path
    else
      welcome_path
    end
  end

  helper_method :sign_in?
  helper_method :current_user

  def remember_me(user)
    user.remember_me!
    cookies[:remember_token]= { value: user.token, expires: 1.day.from_now }
    cookies.signed[:user_id] = user.id
  end

  def forget_me(user)
    user.forget_me!
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  private

  def ensure_sign_in
    redirect_to welcome_path if not sign_in?
  end

end
