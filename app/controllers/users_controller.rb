class UsersController < ApplicationController
  before_action :require_login, only: %i[edit update change_password update_password profile]
  before_action :set_user, only: %i[edit update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, notice: "Conta criada com sucesso! Faça login para continuar."
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def profile
    @user = current_user
  end

  def edit
  end

  def update
    if @user.update(user_update_params)
      redirect_to profile_path, notice: "Cadastro atualizado com sucesso!"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def change_password
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.authenticate(params[:current_password])
      if @user.update(password_params)
        redirect_to profile_path, notice: "Senha alterada com sucesso!"
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :change_password, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Senha atual incorreta."
      render :change_password, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name, :email)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
