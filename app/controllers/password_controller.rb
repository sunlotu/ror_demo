class PasswordController < ApplicationController
  skip_before_action :ensure_sign_in, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    user = User.visit_user(user_params)
    if user
      UserMailer.reset_password(user.id).deliver_now
      flash[:notice] = '重置密码邮件已发送，请注意查收'
      redirect_to sign_in_path
    else
      flash[:alert] = '用户不存在'
      redirect_to :back
    end
  end

  def edit
    @user = User.new(reset_password_token: params[:reset_password_token])
  end

  def update
    begin
      token = user_params[:reset_password_token]
      payload, header = JWT.decode(token, nil, false)
      user = User.find_by_email(payload['data'])
      JWT.decode(token, user.password_digest)
      if user.update(user_params)
        flash[:notice] = '密码重置成功'
        redirect_to sign_in_path
      else
        flash[:alert] = '密码重置失败'
        redirect_to :back
      end
    rescue JWT::ExpiredSignature
      flash[:alert] = '密码重置失效'
      redirect_to :back
    rescue JWT::DecodeError
      flash[:alert] = '非法操作（token）'
      redirect_to :back
    end
  end

  private

  def user_params
    params.require(:users).permit(:login, :password, :password_confirmation, :reset_password_token)
  end
end
