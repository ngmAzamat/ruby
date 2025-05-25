class UsersController < ApplicationController

  def index
    @users = User.all
  end
  
  def edit
    @user = User.find(params[:id])
    @figures = Figure.all
  end
  
  def update
    @user = User.find(params[:id])
    @figures = Figure.all
  
    if @user.update(user_params)
      redirect_to root_path, notice: "Пользователь обновлён"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  
  def new
    @user = User.new
    @figures = Figure.all
  end

  def create
    @user = User.new(user_params)
    @figures = Figure.all # иначе рендер new выдаст ошибку

    if @user.save
      redirect_to root_path, notice: "Пользователь создан"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
