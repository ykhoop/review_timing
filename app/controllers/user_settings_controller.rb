class UserSettingsController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit
    @user_review_settings = @user.user_review_settings.order(:review_number)
  end

  def update
    if @user.update(update_user_review_setting_params)
      flash.now[:success] = t('.success')
      render :edit, status: :unprocessable_entity
    else
      flash.now[:danger] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def update_user_review_setting_params
    params.require(:user).permit(user_review_settings_attributes: [:id, :review_days])
  end

end
