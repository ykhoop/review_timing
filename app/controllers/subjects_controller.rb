class SubjectsController < ApplicationController
  before_action :set_subcject, only: %i[edit update destroy]

  def index
    @subjects = current_user.subjects.order(:id)
  end

  def new
    @subject = Subject.new
  end

  def create
    if current_user.subjects.count >= current_user.user_setting.max_subjects
      redirect_to subjects_path, danger: t('.max_subjects_exceeded')
      return
    end

    @subject = current_user.subjects.build(subject_params)
    if @subject.save
      redirect_to subjects_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @subject || logout && redirect_to(login_path, warning: t('defaults.message.require_login')) && return
  end

  def update
    @subject || logout && redirect_to(login_path, warning: t('defaults.message.require_login')) && return
    if @subject.update(subject_params)
      redirect_to subjects_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @subject || logout && redirect_to(login_path, warning: t('defaults.message.require_login')) && return
    @subject.destroy!
    redirect_to subjects_path, success: t('.success', item: @subject.title)
  end

  private

  def set_subcject
    @subject = Subject.find(params[:id])
    @subject = nil unless current_user.own?(@subject)
  end

  def subject_params
    params.require(:subject).permit(:title, :start_at, :limit_at, :memo)
  end
end
