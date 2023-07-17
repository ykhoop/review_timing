class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :subjects, dependent: :destroy
  has_many :user_review_settings, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_one  :user_setting, dependent: :destroy
  accepts_nested_attributes_for :user_review_settings
  accepts_nested_attributes_for :authentications
  accepts_nested_attributes_for :user_setting

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
  validates :email, presence: true
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }

  enum role: { general: 0, admin: 1 }

  def own?(object)
    id == object.user_id
  end

  def has_line?
    authentications.find_by(provider: 'line').present?
  end

  def self.ransackable_associations(auth_object = nil)
    ["authentications", "subjects", "user_review_settings", "user_setting"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["email", "first_name", "last_name", "role"]
  end
end
