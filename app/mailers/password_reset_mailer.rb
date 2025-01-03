class PasswordResetMailer < ApplicationMailer
  def reset_email
    @user = params[:user]
    @url = edit_password_reset_url(@user.reset_password_token)
    mail(to: @user.email, subject: "Instruções para redefinir sua senha")
  end
end
