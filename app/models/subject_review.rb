class SubjectReview < ApplicationRecord
  belongs_to :subject_detail

  validates :review_type, presence: true
  validates :review_number, presence: true

  enum review_type: { plan: 0, actual: 1 }

  def self.create_reviews!(subject_detail, user)
    counts_of_review_type = 2
    counts_of_review_days = 4
    val_not_set_review_at = 0

    review_days = user.user_review_settings.order(:review_number).pluck(:review_days)
    counts_of_review_type.times do |i|
      counts_of_review_days.times do |j|
        subject_review = subject_detail.subject_reviews.build
        subject_review.review_type = i
        subject_review.review_number = j + 1
        i == SubjectReview.review_types[:plan] && review_days[j].days != val_not_set_review_at ? subject_review.review_at = subject_detail.start_at + review_days[j].days : nil
        subject_review.save!
      end
    end
  end
end
