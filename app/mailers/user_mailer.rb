class UserMailer < ApplicationMailer
  def reset_password_email(user)
    @user = User.find(user.id)
    @url  = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email, subject: t('defaults.app_name') + ' ' + t('password_resets.mail.subject')) do |format|
      format.text
    end
  end
end
