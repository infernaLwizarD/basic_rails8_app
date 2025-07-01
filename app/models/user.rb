class User < ApplicationRecord
  include Discard::Model
  include UserRepository
  include UserRansack
  include UserRoleEnum

  # Include default devise modules. Others available are:
  # :timeoutable
  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :trackable, :validatable, :rememberable,
         :lockable # , :omniauthable, omniauth_providers: [:google_oauth2]

  validates :username, presence: true, format: { with: /\A[a-zA-Z0-9_.]*\z/, multiline: true }, uniqueness: true
  validates :role, presence: true
  validate :validate_username

  attr_writer :login

  before_save do
    username.downcase!
  end

  def login
    @login || username || email
  end

  # Overriding the find_for_database_authentication method for login via username or email
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value',
                                    { value: login.downcase }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end

  private

  def validate_username
    errors.add(:username, :invalid) if User.exists?(email: username)
  end
end
