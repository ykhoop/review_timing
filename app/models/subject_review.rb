class SubjectReview < ApplicationRecord
  belongs_to :subject_detail

  validates :review_type, presence: true
  validates :review_number, presence: true

  enum review_type: { plan: 0, actual: 1 }

  def self.create_reviews!(subject_detail, user)
    review_days = user.user_review_settings.order(:review_number).pluck(:review_days)
    2.times do |i|
      4.times do |j|
        subject_review = subject_detail.subject_reviews.build
        subject_review.review_type = i
        subject_review.review_number = j + 1
        i == 0 && review_days[j].days != 0 ? subject_review.review_at = subject_detail.start_at + review_days[j].days : nil
        subject_review.save!
      end
    end
  end
end
