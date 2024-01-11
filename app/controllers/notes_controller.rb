class NotesController < ApplicationController
  before_action :set_student, only: [:new, :create, :edit, :update, :destroy]

  def new
    @note = @student.notes.build
  end

  def create
    if @student.nil?
      flash[:alert] = "Student not found"
      render plain: "Student not found", status: :not_found
    else
      @note = @student.notes.build(note_params)

      if @note.content.blank?
        flash.now[:alert] = "Note content cannot be blank"
        render :new, status: :unprocessable_entity
      else
        @note.added_by = current_user.email
        @note.added_at = Time.current

        if @note.save
          redirect_to @student, notice: 'Note was successfully created.'
        else
          render :new
        end
      end
    end
  end

  def edit
    @note = find_note
  end

  def update
    @note = find_note
    return redirect_to student_path(@student), alert: 'Note not found.' if @note.nil?

    if @note.update(note_params)
      redirect_to student_path(@student), notice: 'Note was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    redirect_to @student, notice: 'Note was successfully deleted.'
  end

  private

  def set_student
    @student = Student.find_by(id: params[:student_id])
  end

  def find_note
    @student.notes.find_by(id: params[:id]) if @student.present?
  end

  def note_params
    params.require(:note).permit(:content, :student_id)
  end
end