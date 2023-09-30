class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    @user.deliver_reset_password_instructions! if @user
    redirect_to root_path, success: t('.success')
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end
  end

  def update
    @token = params[:id]
    email = params[:user][:email]
    password = params[:user][:password]
    password_confirmation = params[:user][:password_confirmation]

    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end

    if @token.blank?
      not_authenticated
      return
    end

    if email.blank?
      render_when_update_fail(t('.err_msg_email_blank'))
      return
    end

    if email != @user.email
      render_when_update_fail(t('.err_msg_email_not_match'))
      return
    end

    if password.blank?
      render_when_update_fail(t('.err_msg_password_blank'))
      return
    end

    @user.password_confirmation = password_confirmation
    if @user.change_password(password)
      redirect_to root_path, success: t('.success')
    else
      render_when_update_fail
    end
  end

  private

  def render_when_update_fail(err_msg = nil)
    @user.errors.add(:base, err_msg) if err_msg.present?
    flash.now[:danger] = t('.fail')
    render :edit, status: :unprocessable_entity
  end
end
