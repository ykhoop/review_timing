class UserSetting < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true, uniqueness: true
  validates :remind_mail, presence: true
  validates :remind_line, presence: true
  validates :remind_browser, presence: true
  validates :max_subjects, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_subject_details, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  enum remind_mail: { mail_not_receive: false, mail_receive: true }
  enum remind_line: { line_not_receive: false, line_receive: true }
  enum remind_browser: { browser_not_receive: false, browser_receive: true }
end
