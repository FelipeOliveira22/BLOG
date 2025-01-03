class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      @user.generate_password_reset_token!
      PasswordResetMailer.with(user: @user).reset_email.deliver_now
      redirect_to login_path, notice: "Instruções de redefinição de senha enviadas para o e-mail."
    else
      flash.now[:alert] = "E-mail não encontrado."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(reset_password_token: params[:token])
    redirect_to login_path, alert: "Token inválido ou expirado." if @user.nil? || @user.password_reset_token_expired?
  end

  def update
    @user = User.find_by(reset_password_token: params[:token])
    if @user&.update(password_params)
      @user.update(reset_password_token: nil, reset_password_sent_at: nil)
      redirect_to login_path, notice: "Senha redefinida com sucesso!"
    else
      flash.now[:alert] = "Erro ao redefinir a senha."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
