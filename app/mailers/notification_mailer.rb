class NotificationMailer < ApplicationMailer
  default from: 'ubuntu@localhost'

  def review_notification(email, body)
    @body = body
    mail(to: email, subject: t('notifications.title'))
  end

end
