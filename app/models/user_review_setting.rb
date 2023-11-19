class UserReviewSetting < ApplicationRecord
  belongs_to :user

  validates :review_number, presence: true
  validates :review_days, presence: true

  def self.create_review_days!(user)
    counts_of_review_days = 4

    system_review_days = SystemReviewSetting.order(:review_number).pluck(:review_days)
    counts_of_review_days.times do |j|
      user_review_setting = user.user_review_settings.build
      user_review_setting.review_number = j + 1
      user_review_setting.review_days = system_review_days[j]
      user_review_setting.save!
    end
  end
end
