class WarsController < ApplicationController
  def show
    @war = War.find(params[:id])
  end
  
  def index
    @wars = War.all
  end

  def new
    @war = War.new
  end

  def create
    @war = War.new(war_params)
    if @war.save
      redirect_to wars_path, notice: "Война создана"
    else
      render :new
    end
  end

  def edit
    @war = War.find(params[:id])
  end

  def update
    @war = War.find(params[:id])
    if @war.update(war_params)
      redirect_to wars_path, notice: "Война обновлена"
    else
      render :edit
    end
  end

  private

  def war_params
    params.require(:war).permit(
      :name,
      :first_belligerents,
      :second_belligerents,
      :number,
      :first_year,
      :last_year,
      :who_win,
      :name_of_the_peace_treaty
    )
  end
end
