class Document < ApplicationRecord
  validates :code, presence: true
  validates :description, presence: true
  validates :content, presence: true
end
