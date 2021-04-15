class NotesController < ApplicationController
  def index
  end

  def show
  end

  def edit
  end

  def new
  	@note = Note.new
  	@note.company_id = params[:id]
  	@note.author = current_user
  end

  def create
  	@note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

	def note_params
		params.require(:note).permit(:body, :company_id, :author, :subject)
	end
end
