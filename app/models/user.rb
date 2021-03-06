class User < ActiveRecord::Base
  has_many :games
  has_many :pieces

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.username = auth.info.name
      user.password = Devise.friendly_token[0, 20]
    end
  end

  ## This is causing an issue with sign up page, disable for now
  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if data == session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
  #       user.email = data['email'] if user.email.blank?
  #     end
  #   end
  # end
end
