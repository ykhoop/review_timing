namespace :notification do
  desc "復習を行うべき科目を通知する"
  task line_notification: :environment do
    ReviewNotificationJob.line_notification
  end

  task mail_notification: :environment do
    ReviewNotificationJob.mail_notification
  end
end
