class SearchController < ApplicationController
  def index
    if params[:q].present?
      @wars = War.search(params[:q])
      @countries = Country.search(params[:q])
      @figures = Figure.search(params[:q])
      @battles = Battle.search(params[:q])
      @users = User.search(params[:q])
      @events = Event.search(params[:q])
    else
      @wars = []
      @countries = []
      @figures = []
      @events = []
      @battles = []
      @users = []
    end
  end
end