class Document < ApplicationRecord
  validates :code, presence: true
  validates :description, presence: true
  validates :content, presence: true

  def self.contact_url
    Document.find_by(code: 'contact').content
  end
end
