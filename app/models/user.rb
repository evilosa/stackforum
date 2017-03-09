class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions
  has_many :answers
  has_many :identities

  def author_of?(object)
    self == object.user
  end

  def create_identity(auth)
    identities.create(provider: auth.provider, uid: auth.uid.to_s)
  end

  def email_confirmed?(auth)
    email != "#{auth.provider}_#{auth.uid}@stackforum.com"
  end

  def self.find_for_oauth(auth)
    identity = Identity.where(provider: auth.provider, uid: auth.uid.to_s).first
    return identity.user if identity

    email = auth.info[:email] if auth.info && auth.info[:email]
    email ||= "#{auth.provider}_#{auth.uid}@stackforum.com"

    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.skip_confirmation!
      user.save
    end

    user.create_identity(auth)
    user
  end
end
