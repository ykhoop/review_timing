class Subject < ApplicationRecord
  belongs_to :user

  has_many :subject_details, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :memo, length: { maximum: 65_535 }

end
