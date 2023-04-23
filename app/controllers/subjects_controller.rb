class SubjectsController < ApplicationController
  before_action :set_subcject, only: %i[edit update destroy]

  def index
    @subjects = current_user.subjects
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = current_user.subjects.build(subject_params)
    if @subject.save
      redirect_to subjects_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @subject.update(subject_params)
      redirect_to subjects_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @subject.destroy!
    redirect_to subjects_path, success: t('.success', item: @subject.title)
  end

  private

  def set_subcject
    @subject = current_user.subjects.find(params[:id])
  end

  def subject_params
    params.require(:subject).permit(:title, :start_at, :limit_at, :memo)
  end
end
