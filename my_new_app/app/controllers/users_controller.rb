class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :delete]
  
  # GET /users
  def index
    if params[:q].present?
      @users = User.search(params[:q])
    else
      @users = User.all
    end
  end

  # GET /users/:id
  def show
    # @user задаётся через before_action
  end

  # GET /users/:id/delete
  def delete
    # @user уже задан в set_user
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    redirect_to users_url, notice: "User was successfully deleted."
  end


  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @user уже задан set_user
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    redirect_to users_url, notice: "User was successfully deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
