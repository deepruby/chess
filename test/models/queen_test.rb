require 'test_helper'

class QueenTest < ActiveSupport::TestCase
  setup :game_and_queen

  test 'Legal vertical move' do
    assert @queen.legal_move?(3, 4)
  end

  test 'Legal horizontal move' do
    assert @queen.legal_move?(7, 3)
  end

  test 'Legal move, captures opponent piece' do
    assert @queen.legal_move?(3, 6)
  end

  test 'Legal diagonal move' do
    assert @queen.legal_move?(4, 4)
  end

  test 'Illegal obstructed move' do
    assert_not @queen.legal_move?(3, 7)
  end

  test 'Illegal move, own piece occupies square' do
    assert_not @queen.legal_move?(3, 1)
  end

  test 'Illegal move, not on board' do
    assert_not @queen.legal_move?(8, 3)
  end

  private

  def game_and_queen
    @game = Game.create(name: 'lolomg', white_player_id: 1)
    @queen = @game.pieces.create(
      type: 'Queen',
      x_position: 3,
      y_position: 3,
      player_id: 1)
  end
end
