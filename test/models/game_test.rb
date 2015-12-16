require 'test_helper'

class GameTest < ActiveSupport::TestCase
  setup :game
  
  test 'correct number of pieces' do
    assert_equal @game.pieces.count, 32
  end

  test 'check? - false' do
    assert_equal false, @game.check?(@black_player.id)
  end

  test 'check? - true' do
    @white_queen.update_attributes(x_position: @black_king.x_position, y_position: 6)
    @black_pawn.update_attributes(x_position: nil, y_position: nil)
    @black_pawn.reload
    @white_queen.reload
    assert_equal true, @game.check?(@black_player.id)
  end

  private

  def game
    @black_player = FactoryGirl.create(:user)
    @white_player = FactoryGirl.create(:user)
    @game = Game.create(name: 'lolomg', black_player_id: @black_player.id, white_player_id: @white_player.id)
    @black_king = @game.pieces.find_by(type: 'King', player_id: @black_player.id)
    @black_pawn = @game.pieces.find_by(type: 'Pawn', player_id: @black_player.id, x_position: @black_king.x_position)
    @white_queen = @game.pieces.find_by(type: 'Queen', player_id: @white_player.id)
  end
end
