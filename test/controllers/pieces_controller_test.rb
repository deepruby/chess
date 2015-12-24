require 'test_helper'

class PiecesControllerTest < ActionController::TestCase
  setup :game_setup

  test 'update - moved' do
    put :update, id: @white_pawn, piece: {x_position: 1, y_position: 3}
    assert_response :success
    @white_pawn.reload
    assert_equal 3, @white_pawn.y_position
  end

  test 'update - not moved' do
    put :update, id: @white_pawn, piece: {x_position: 1, y_position: 4}
    assert_equal 'Not a valid move', flash[:alert]
    @white_pawn.reload
    assert_equal 1, @white_pawn.y_position
  end

  test 'update - moved, with capture' do
    @black_pawn.update_attributes(x_position: 2, y_position: 2)
    @white_pawn.reload
    @black_pawn.reload
    put :update, id: @white_pawn, piece: {x_position: 2, y_position: 2}
    assert_response :success
    @white_pawn.reload
    @black_pawn.reload
    assert_equal [2,2], [@white_pawn.x_position, @white_pawn.y_position]
    assert_equal [nil,nil], [@black_pawn.x_position, @black_pawn.y_position]
  end

  private

  def game_setup
    @white_player = FactoryGirl.create(:user)
    @black_player = FactoryGirl.create(:user)
    sign_in @white_player
    @game = Game.create(name: 'test', white_player_id: @white_player.id, black_player_id: @black_player.id)
    @white_pawn = @game.pieces.find_by(type: 'Pawn', player_id: @white_player.id, x_position: 1)
    @black_pawn = @game.pieces.find_by(type: 'Pawn', player_id: @black_player.id, x_position: 1)
  end
end
