class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    if User.count >= SystemSetting.max_users
      redirect_to root_path, danger: t('.max_users_exceeded')
      return
    end

    @user = User.new(user_params)
    if @user.save
      UserReviewSetting.create_review_days!(@user)
      @user.build_user_setting(max_subjects: SystemSetting.max_user_subjects, max_subject_details: SystemSetting.max_user_subject_details).save!

      redirect_to login_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
