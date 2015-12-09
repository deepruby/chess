require 'test_helper'

class KingTest < ActiveSupport::TestCase
  setup :game_and_king

  test 'Legal vertical move' do
    assert @king.legal_move?(4, 3)
  end

  test 'Legal diagonal move' do
    assert @king.legal_move?(5, 3)
  end

  test 'Illegal move' do
    assert_not @king.legal_move?(5, 4)
  end

  private

  def game_and_king
    @game = Game.create(name: 'lolomg', white_player_id: 1)
    @king = @game.pieces.create(type: 'King', x_position: 4, y_position: 2)
  end
end
