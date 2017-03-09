class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions
  has_many :answers
  has_many :identities

  def author_of?(object)
    self == object.user
  end

  def self.find_for_oauth(auth)
    identity = Identity.where(provider: auth.provider, uid: auth.uid.to_s).first
    return identity.user if identity

    if auth.key?('info') && auth.info.key?('email')
      email = auth.info[:email]
    else
      email = "#{auth.uid.to_s}@stackforum.com"
    end
    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end

    user.identities.create(provider: auth.provider, uid: auth.uid.to_s)
    user
  end
end
