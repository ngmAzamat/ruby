class ThemesController < ApplicationController
  def set
    @theme = cookies[:theme] || "light"  # по умолчанию "light"
    # cookies[:theme] = params[:theme]

    puts @theme

    if @theme == "dark"
      @theme = "light"
    else
      @theme = "dark"
    end

    puts @theme

    cookies[:theme] = @theme
    redirect_back fallback_location: root_path
  end
end
