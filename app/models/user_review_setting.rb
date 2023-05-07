class UserReviewSetting < ApplicationRecord
  belongs_to :user

  validates :review_number, presence: true
  validates :review_days, presence: true

  def self.create_review_days(user)
    4.times do |j|
      user_review_setting = user.user_review_settings.build
      user_review_setting.review_number = j + 1
      user_review_setting.review_days = j + 1 + 5
      user_review_setting.save!
    end
  end

end
