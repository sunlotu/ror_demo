class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password.subject
  #

  def welcome(email)
    @email = email
    mail to: @email, subject: '欢迎使用哟'
  end

  def reset_password(user_id)
    @user = User.find(user_id)
    @token = @user.encode_token
    mail to: @user.email, subject: '重置密码'
  end
end
