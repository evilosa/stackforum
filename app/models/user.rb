class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions
  has_many :answers
  has_many :identities, dependent: :destroy

  scope :without, ->(user) { where.not(id: user) }

  def author_of?(object)
    self == object.user
  end

  def create_identity(auth)
    identities.create(provider: auth[:provider], uid: auth[:uid].to_s)
  end

  def email_confirmed?(auth)
    email != "#{auth.provider}_#{auth.uid}@stackforum.com"
  end

  def self.confirm_oauth_email(auth)
    User.transaction do
      # Возможны две ситуации
      user = User.find_by_email(auth[:email])
      if user
        # 1. Пользователь с новым email уже существует в базе
        # Нам нужно найти его, задать ему идентити и удалить временного
        temp_user = User.find_by_email(auth[:temp_email])
        if temp_user && temp_user.confirmation_token == auth[:confirmation_token]
          user.create_identity(auth)
          temp_user.destroy
        end
      else
        # 2. Пользователя с таким email не существует,
        # меняем почту у временного
        temp_user = User.find_by_email(auth[:temp_email])
        if temp_user && temp_user.confirmation_token == auth[:confirmation_token]
          temp_user.email = auth[:email]
          temp_user.save
        end
      end
    end
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
      user.confirmation_token = Devise.token_generator.generate(User, :confirmation_token)
      user.save
    end

    user.create_identity(auth)
    user
  end
end
