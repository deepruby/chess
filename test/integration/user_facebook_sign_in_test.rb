require 'test_helper'
OmniAuth.config.test_mode = true

def setup 
  Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] 
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  OmniAuth.config.mock_auth[:facebook] = nil
end

class UserFacebookSignInTest < ActionDispatch::IntegrationTest

  test "log in with facebook - email doesn't exist" do

    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '123545',
      :info => {:email => 'test@email.com'}
    })
      
    assert_difference 'User.count' do
      get "/users/auth/facebook/callback"
    end

    assert_equal 'test@email.com', User.last.email
    assert_redirected_to root_path
  end

  test "log in with facebook - email exists" do

    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '123545',
      :info => {:email => 'test@email.com'}
    })
      
    get "/users/auth/facebook/callback"
    delete "/users/sign_out" 
    get "/users/auth/facebook/callback"

    assert_equal 1, User.count
    assert_redirected_to root_path
  end

  test "log in with facebook - name" do

    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '123545',
      :info => {:email => 'test@email.com', :name => 'test user'}
    })
      
    assert_difference 'User.count' do
      get "/users/auth/facebook/callback"
    end

    assert_equal 'test user', User.last.username
    assert_redirected_to root_path
  end

end
