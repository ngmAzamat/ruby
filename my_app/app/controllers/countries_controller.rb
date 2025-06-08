class CountriesController < ApplicationController
  before_action :require_login

  def index
    @countries = Country.all
  end

  def new
    @country = Country.new
  end

  def create
    @country = Country.new(country_params)
    if @country.save
      redirect_to countries_path, notice: "Страна добавлена!"
    else
      render :new
    end
  end

  def edit
    @country = Country.find(params[:id])
  end

  def update
    @country = Country.find(params[:id])
    if @country.update(country_params)
      redirect_to countries_path, notice: "Страна обновлена"
    else
      render :edit
    end
  end

  def destroy
    @country = Country.find(params[:id])
    @country.destroy
    redirect_to countries_path, notice: 'Старана была успешно удалёна.'
  end

  private

  def require_login
    unless current_user
      redirect_to '/sign_in'
    end
  end

  def country_params
    params.require(:country).permit(
    :name,
    :first_year,
    :last_year,
    :army,
    :area,
    :population
    )
  end
end
