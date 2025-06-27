class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy, :delete]
  before_action :require_login

  # GET /notes
  def index
    if params[:q].present?
      @notes = Note.search(params[:q])
    else
      @notes = Note.all
    end
  end

  # GET /notes/:id
  def show
  end

  # GET /notes/:id/delete
  def delete
    # @note уже задан
  end

  # DELETE /notes/:id
  def destroy
    @note.destroy
    redirect_to notes_url, notice: "Note was successfully deleted."
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # POST /notes
  def create
    @note = Note.new(note_params)
    if @note.save
      redirect_to @note, notice: "Note was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /notes/:id/edit
  def edit
  end

  # PATCH/PUT /notes/:id
  def update
    if @note.update(note_params)
      redirect_to @note, notice: "Note was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
