class SubjectDetail < ApplicationRecord
  belongs_to :subject

  has_many :subject_reviews, dependent: :destroy

  validates :chapter, length: { maximum: 255 }
  validates :start_page, numericality: { in: 1..10000 }
  validates :end_page, numericality: { in: 1..10000 }
  validates :start_at, presence: true
end
