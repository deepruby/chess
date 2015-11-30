require 'test_helper'

class KingTest < ActiveSupport::TestCase
	setup :game_and_king

  test 'Should be legal moves' do
    assert @king.legal_move?(4, 1)
    assert @king.legal_move?(5, 1)
  end

	private

  def game_and_king
    @game = Game.create(:name => 'lolomg', :white_player_id => 1)
    @king = @game.pieces.find_by(type: 'King', player_id: 1)
  end
end
