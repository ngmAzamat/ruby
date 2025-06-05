class CountriesController < ApplicationController
  def index
    @countries = Country.all
    if current_user
    else
      redirect_to '/sign_in'
    end
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

  private

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
