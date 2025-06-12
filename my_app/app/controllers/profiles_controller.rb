class ProfilesController < ApplicationController
  before_action :require_login

  def index
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_path, notice: "Пользователь обновлён"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :image)
  end

  def require_login
    unless current_user
      redirect_to '/sign_in'
    end
  end
end