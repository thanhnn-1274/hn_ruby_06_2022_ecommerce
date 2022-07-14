class User < ApplicationRecord
  enum role: {admin: 0, customer: 1}
  USER_ATTRS = %w(name email password password_confirmation).freeze
  GET_ALL = %w(id name email phone_num address).freeze

  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  before_save :downcase_email

  validates :email, presence: true,
    format: {with: Settings.user.VALID_EMAIL_REGEX},
    uniqueness: true

  validates :name, presence: true,
    length: {maximum: Settings.user.name_validates.name_max_length}

  validates :password, presence: true,
    length: {minimum: Settings.user.password_validates.password_min_length},
    if: :password

  has_secure_password

  scope :asc_name, ->{order name: :asc}
  scope :get_all, ->{select(GET_ALL).where(role: :customer)}

  private

  def downcase_email
    email.downcase!
  end
end
