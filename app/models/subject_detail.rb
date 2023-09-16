class SubjectDetail < ApplicationRecord
  belongs_to :subject

  has_many :subject_reviews, dependent: :destroy
  accepts_nested_attributes_for :subject_reviews

  validates :chapter, presence: true, length: { maximum: 255 }
  validates :start_page, numericality: { in: 1..10_000 }
  validates :end_page, numericality: { in: 1..10_000 }
  validates :start_at, presence: true
end
