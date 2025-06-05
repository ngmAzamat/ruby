class FiguresController < ApplicationController
  def index
    @figures = Figure.all
    if current_user
    else
      redirect_to '/sign_in'
    end
  end

  def new
    @figure = Figure.new
  end

  def create
    @figure = Figure.new(figure_params)
    if @figure.save
      redirect_to figures_path, notice: "Добавлено!"
    else
      render :new
    end
  end

  def edit
    @figure = Figure.find(params[:id])
  end

  def update
    @figure = Figure.find(params[:id])
    if @figure.update(figure_params)
      redirect_to figures_path, notice: "Личность обновлена"
    else
      render :edit
    end
  end

  private

  def figure_params
    params.require(:figure).permit(:first_name, :last_name, :number, :birth_year, :death_year, :occupation)
  end
end
