class PasswordsController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    current_password = params[:user][:current_password]
    password = params[:user][:password]

    if User.authenticate(@user.email, current_password).nil?
      render_when_update_fail(t('.err_msg_current_password_not_match'))
      return
    end

    if password.blank?
      render_when_update_fail(t('.err_msg_password_blank'))
      return
    end

    if current_password == password
      render_when_update_fail(t('.err_msg_password_same_as_current_password'))
      return
    end

    if @user.update(user_params)
      redirect_to password_users_path, success: t('.success')
    else
      render_when_update_fail
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:current_passowrd, :password, :password_confirmation)
  end

  def render_when_update_fail(err_msg = nil)
    @user.errors.add(:base, err_msg) if err_msg.present?
    flash.now[:danger] = t('.fail')
    render :edit, status: :unprocessable_entity
  end
end
