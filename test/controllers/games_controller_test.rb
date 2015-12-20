require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  test 'show' do
    game = FactoryGirl.create(:game)
    get :show, id: game.id
    assert_response :success
  end

  test 'index' do
    get :index
    assert_response :success
  end

  test 'new not signed in' do
    get :new
    assert_redirected_to new_user_session_path
  end

  test 'new' do
    user = FactoryGirl.create(:user)
    sign_in user
    get :new
    assert_response :success
  end

  test 'create not signed in' do
    assert_no_difference 'Game.count' do
      post :create, game: {
        name: 'yolo'
      }
    end
    assert_redirected_to new_user_session_path
  end

  test 'create' do
    user = FactoryGirl.create(:user)
    sign_in user

    assert_difference 'Game.count' do
      post :create, game: {
        name: 'yolo',
        white_player_id: user.id
      }
    end
    assert_redirected_to game_path(Game.last)
  end

  test 'join' do
    user = FactoryGirl.create(:user)

    @game = FactoryGirl.create(:game)

    sign_in user

    put :join, id: @game, game: { black_player_id: user.id }

    assert_response :found
    assert_equal Game.last.black_player_id, user.id
  end

  test 'join own game' do
    user = FactoryGirl.create(:user)

    @game = Game.create(
      name: 'yolo',
      white_player_id: user.id)

    sign_in user

    put :join, id: @game.id, game: {
      black_player_id: user.id
    }

    assert_response :forbidden
  end
end
