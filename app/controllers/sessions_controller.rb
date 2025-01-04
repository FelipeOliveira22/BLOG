class SessionsController < ApplicationController
  def new
    # Renderiza a página de login
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to posts_path, notice: "Login realizado com sucesso!"
    else
      flash.now[:alert] = "Email ou senha inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to params[:redirect_to] || login_path, notice: "Você saiu com sucesso."
  end
end
