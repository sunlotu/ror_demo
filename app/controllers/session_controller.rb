class SessionController < ApplicationController
  skip_before_action :ensure_sign_in

  def new
    @user = User.new
  end

  def create
    if user = User.auth_user(user_params)
      user_params[:remember_me].to_i == 1 ? remember_me(user) : forget_me(user)
      sign_in user
      redirect_to after_sign_in_path, notice: '登录成功'
    else
      flash[:alert] = '登录失败'
      @user = User.new(user_params)
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to welcome_path
  end

  private

  def user_params
    params.require(:user).permit(:login, :password, :remember_me)
  end

end
