class SessionsController < ApplicationController
  before_action :require_login, except: [:new, :create]
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Вы вошли!"
    else
      flash.now[:alert] = "Неверный email или пароль"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: "Вы вышли."
  end
end