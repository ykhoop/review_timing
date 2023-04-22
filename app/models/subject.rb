class Subject < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 255 }
  validates :memo, length: { maximum: 65_535 }

end
