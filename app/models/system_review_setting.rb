class SystemReviewSetting < ApplicationRecord
  validates :review_number, presence: true
  validates :review_days, presence: true
end
