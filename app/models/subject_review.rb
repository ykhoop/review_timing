class SubjectReview < ApplicationRecord
  belongs_to :subject_detail

  validates :review_type, presence: true
  validates :review_number, presence: true

  enum review_type: { plan: 0, actual: 1 }


  def self.create_revies(subject_detail)
    2.times do |i|
      4.times do |j|
        @subject_review = SubjectReview.new
        @subject_review.subject_detail_id = subject_detail.id
        @subject_review.review_type = i
        @subject_review.review_number = j + 1
        i == 0 ? @subject_review.review_at = Date.today + (j + 1).days : nil
        @subject_review.save!
      end
    end
  end
end
