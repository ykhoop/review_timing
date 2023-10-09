class SystemSetting < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :description, presence: true

  def self.max_users
    SystemSetting.find_by(code: 'max_users').int_value
  end

  def self.max_user_subjects
    SystemSetting.find_by(code: 'max_user_subjects').int_value
  end

  def self.max_user_subject_details
    SystemSetting.find_by(code: 'max_user_subject_details').int_value
  end

  def self.notification_interval
    SystemSetting.find_by(code: 'notification_interval').int_value
  end
end
