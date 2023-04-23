class SubjectDetailsController < ApplicationController
  before_action :set_subcject, only: %i[index new create]
  before_action :set_subcject_detail, only: %i[edit update destroy]

  def index
    # @subject = Subject.find(params[:subject_id])
    @subject_details = @subject.subject_details
  end

  def new
    # @subject = Subject.find(params[:subject_id])
    @subject_detail = SubjectDetail.new
  end

  def create
    # @subject = Subject.find(params[:subject_id])
    @subject_detail = SubjectDetail.new(subject_detail_params)
    if @subject_detail.save

      redirect_to subject_subject_details_path(@subject.id), success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @subject_detail.update(subject_detail_update_params)
      redirect_to subject_subject_details_path(@subject_detail.subject_id), success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @subject_detail.destroy!
    redirect_to subject_subject_details_path(@subject_detail.subject_id), success: t('.success', item: @subject_detail.chapter)
  end

  private

  def set_subcject
    @subject = Subject.find(params[:subject_id])
    if ! current_user.own?(@subject)
      logout
      flash[:warning] = t ('defaults.message.require_login')
      redirect_to login_path
    end
  end

  def set_subcject_detail
    @subject_detail = SubjectDetail.find(params[:id])
    # @subject = Subject.find(@subject_detail.subject_id)
    if ! current_user.own?(@subject_detail.subject)
      logout
      flash[:warning] = t ('defaults.message.require_login')
      redirect_to login_path
    end
  end

  def subject_detail_params
    params.require(:subject_detail).permit(:chapter, :start_page, :end_page, :start_at).merge(subject_id: params[:subject_id])
  end

  def subject_detail_update_params
    params.require(:subject_detail).permit(:chapter, :start_page, :end_page, :start_at)
  end

end
