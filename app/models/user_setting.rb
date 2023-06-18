class UserSetting < ApplicationRecord
  belongs_to :user

  enum remind_mail: { mail_not_receive: false, mail_receive: true }
  enum remind_line: { line_not_receive: false, line_receive: true }
  enum remind_browser: { browser_not_receive: false, browser_receive: true }
end
