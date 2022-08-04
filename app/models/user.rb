class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :omniauthable,
         omniauth_providers: [:facebook, :google_oauth2]
  enum role: {admin: 0, customer: 1}
  USER_ATTRS = %w(name email password password_confirmation).freeze
  GET_ALL = %w(id name email phone_num address).freeze
  UPDATE_ATTRS = %w(name email password password_confirmation phone_num address
                  avatar).freeze
  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :avatar
  before_save :downcase_email

  validates :email, presence: true,
    format: {with: Settings.user.VALID_EMAIL_REGEX},
    uniqueness: true

  validates :name, presence: true,
    length: {maximum: Settings.user.name_validates.name_max_length,
             minimum: Settings.user.name_validates.name_min_length}

  validates :password, presence: true,
    length: {minimum: Settings.user.password_validates.password_min_length},
    if: :password, allow_nil: true

  validates :address, length: {minimum: Settings.user.address_min_length,
                               maximum: Settings.user.address_max_length},
                               allow_nil: true

  validates :phone_num, length: {minimum: Settings.user.min_phone,
                                 maximum: Settings.user.max_phone},
                                 allow_nil: true

  validates :avatar,
            content_type: {in: Settings.user.image.image_path,
                           message: :wrong_format},
                          allow_nil: true

  scope :asc_name, ->{order name: :asc}
  scope :get_all, ->{select(GET_ALL).where(role: :customer)}

  scope :search_by_name, (lambda do |key|
    where "name LIKE ? or phone_num LIKE ? ", "%#{key}%", "%#{key}%"
  end)

  class << self
    def omniauth_user auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
        user.uid = auth.uid
        user.provider = auth.provider
      end
    end
  end

  private

  def downcase_email
    email.downcase!
  end
end
