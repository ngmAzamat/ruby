class UsersController < ApplicationController
  before_action :require_login

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_path, notice: "Пользователь обновлён"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_destroy
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: 'Пользователь был успешно удалён.'
  end

  def create
    @user = User.new(user_params.except(:image)) # важно: без image

    if @user.save
      @user.image.attach(user_params[:image]) if user_params[:image].present?
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Регистрация успешна!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
  end

  def require_login
    unless current_user
      redirect_to '/sign_in'
    end
  end
end