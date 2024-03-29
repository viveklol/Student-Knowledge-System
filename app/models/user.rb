class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable, 
  #        :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]
  
  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0,20]
  #     user.full_name = auth.info.name
  #     user.avatar_url = auth.info.image
  #     #user.skip_confirmation!
  #   end
  # end

  validates :email, presence: true, uniqueness: {case_sensitive: false}

  passwordless_with :email
  
end