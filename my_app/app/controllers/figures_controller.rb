class FiguresController < ApplicationController
  before_action :require_login

  def index
    
    @figures = Figure.all
    if current_user
    else
      redirect_to '/sign_in'
    end
  end

  def destroy
    @figure = Figure.find(params[:id])
    @figure.destroy
    redirect_to figures_path, notice: 'Личность была успешно удалёна.'
  end

  def new
    @figure = Figure.new
    if current_user
    else
      redirect_to '/sign_in'
    end
  end

  def create
    if current_user
    else
      redirect_to '/sign_in'
    end
    @figure = Figure.new(figure_params)
    if @figure.save
      redirect_to figures_path, notice: "Добавлено!"
    else
      render :new
    end
  end

  def edit
    if current_user
    else
      redirect_to '/sign_in'
    end
    @figure = Figure.find(params[:id])
  end

  def update
    if current_user
    else
      redirect_to '/sign_in'
    end
    @figure = Figure.find(params[:id])
    if @figure.update(figure_params)
      redirect_to figures_path, notice: "Личность обновлена"
    else
      render :edit
    end
  end

  private
  def require_login
    unless current_user
      redirect_to '/sign_in'
    end
  end

  def figure_params
    params.require(:figure).permit(:first_name, :last_name, :number, :birth_year, :death_year, :occupation)
  end
end
