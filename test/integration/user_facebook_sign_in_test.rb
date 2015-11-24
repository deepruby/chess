require 'test_helper'
OmniAuth.config.test_mode = true

def setup 
  Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] 
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
end

class UserFacebookSignInTest < ActionDispatch::IntegrationTest

  test "log in with facebook" do

    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '123545',
      :info => {:email => 'test@email.com'}
    })
      
      assert_difference 'User.count' do
        get "/users/auth/facebook/callback"
      end

      assert_redirected_to root_path
      assert_equal 'test@email.com', User.last.email
  end
end