class SubjectDetailsController < ApplicationController
  before_action :set_subcject, only: %i[index new create]
  before_action :set_subcject_detail, only: %i[edit update destroy review_time update_review_time]

  def index
    # @subject = Subject.find(params[:subject_id])
    @subject_details = @subject.subject_details.order(:id)
  end

  def new
    # @subject = Subject.find(params[:subject_id])
    @subject_detail = SubjectDetail.new
  end

  def create
    # @subject = Subject.find(params[:subject_id])
    @subject_detail = SubjectDetail.new(subject_detail_params)
    if @subject_detail.save

      # ユーザーの復習日数設定を取得
      review_days = []
      4.times do |i|
        review_days.push(current_user.user_review_settings.where(review_number: i + 1).first.review_days)
      end

      # ここで、subject_reviewを作成する
      SubjectReview.create_reviews(@subject_detail, review_days)

      redirect_to subject_subject_details_path(@subject.id), success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @subject_detail.update(update_subject_detail_params)
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

  def review_time
    @subject_reviews = @subject_detail.subject_reviews.order(:review_type, :review_number)
    # @subject_reviews_actual = @subject_detail.subject_reviews.where(review_type: 'actual').order(:review_type, :review_number)
  end

  def update_review_time
    # binding.break
    if @subject_detail.update(update_subject_review_params)
      redirect_to subject_subject_details_path(@subject_detail.subject_id), success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
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

  def update_subject_detail_params
    params.require(:subject_detail).permit(:chapter, :start_page, :end_page, :start_at)
  end

  def update_subject_review_params
    params.require(:subject_detail).permit(subject_reviews_attributes: [:id, :review_at])
    # params.require(:subject_detail).permit(subject_reviews_attributes: [:id, :review_type, :review_number, :review_at])
  end

end
