class SubjectsController < ApplicationController
  def new
    @subject = Subject.new
  end

  def create
    @subject = current_user.subjects.build(subject_params)
    if @subject.save
      redirect_to top_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def subject_params
    params.require(:subject).permit(:title, :start_at, :limit_at, :memo)
  end
end
