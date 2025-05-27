class BattlesController < ApplicationController
  def index
    @battles = Battle.all
  end

  def new
    @battle = Battle.new
  end

  def create
    @battle = Battle.new(battle_params)
    if @battle.save
      redirect_to battles_path, notice: "Битва добавлена!"
    else
      render :new
    end
  end

  def edit
    @battle = Battle.find(params[:id])
  end

  def update
    @battle = Battle.find(params[:id])
    if @battle.update(battle_params)
      redirect_to battles_path, notice: "Битва обновлена"
    else
      render :edit
    end
  end

  private

  def battle_params
    params.require(:battle).permit(
      :name,
      :number,
      :first_belligerents,
      :second_belligerents,
      :date,
      :who_win,
      :army_of_first_belligerents,
      :army_of_second_belligerents
    )
  end
end
