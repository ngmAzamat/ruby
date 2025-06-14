class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

def create
  @user = User.new(user_params)

  if @user.save
    session[:user_id] = @user.id
    redirect_to root_path, notice: "Регистрация успешна!"
  else
    render :new, status: :unprocessable_entity # ВАЖНО: render, а не redirect
  end
end


  private

def user_params
  params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
end
end
