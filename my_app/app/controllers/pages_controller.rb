class PagesController < ApplicationController
  def home
  end

  def about
    render "about"
  end

  def abouts
    render "about"
  end
  
  def courses
  end

  def data
    user_input = params[:user_input]
    logger.info "Получен текст: #{user_input}"
    render json: { status: "ok", message: "Вы ввели: #{user_input}", version: "1.0" }
  end
end
