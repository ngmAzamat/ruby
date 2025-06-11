class EventsController < ApplicationController
  before_action :require_login

  def show
    @event = Event.find(params[:id])
  end
  
  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to events_path, notice: "Событие создана"
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to events_path, notice: "Событие обновлена"
    else
      render :edit
    end
  end

  def confirm_destroy
    @event = Event.find(params[:id])
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: "Событие удалена."
  end


  private

  def require_login
    unless current_user
      redirect_to '/sign_in'
    end
  end

  def event_params
    params.require(:event).permit(
      :name,
      :date,
      :description,
      :image,
      :place
    )
  end
end
