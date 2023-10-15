class User < ApplicationRecord
  authenticates_with_sorcery!
  attr_accessor :current_password

  has_many :subjects, dependent: :destroy
  has_many :user_review_settings, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_one  :user_setting, dependent: :destroy
  accepts_nested_attributes_for :user_review_settings
  accepts_nested_attributes_for :authentications
  accepts_nested_attributes_for :user_setting

  validates :password, presence: true, length: { minimum: 8, maximum: 255 }, if: lambda {
                                                                                   new_record? || changes[:crypted_password]
                                                                                 }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates_format_of :password, with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).*\z/, message: :not_included_up_low_alpha_num, if: lambda {
                                                                                                                                 new_record? || changes[:crypted_password]
                                                                                                                               }

  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }

  enum role: { general: 0, admin: 1 }

  def own?(object)
    id == object.user_id
  end

  def has_line?
    authentications.find_by(provider: 'line').present?
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[authentications subjects user_review_settings user_setting]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[email first_name last_name role]
  end
end
