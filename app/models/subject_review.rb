class SubjectReview < ApplicationRecord
  belongs_to :subject_detail

  validates :review_type, presence: true
  validates :review_number, presence: true

  enum review_type: { plan: 0, actual: 1 }
end
