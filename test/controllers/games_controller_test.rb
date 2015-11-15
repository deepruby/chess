require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  test "Games new" do
    get :new
    assert_response :success  
  end

  test "Games create" do
    assert_difference 'Game.count' do
      post :create, :game => {:name => "test"}
    end

    assert_redirected_to game_path(Game.last)
  end

  test "Games show" do
    game = FactoryGirl.create(:game)
    get :show, :id => game.id
  end

  test "Games index" do
    get :index
    assert_response :success  
  end
end
