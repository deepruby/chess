require 'test_helper'

class RookTest < ActiveSupport::TestCase
  setup :game_and_rook

  test '3,7 is obstructed' do
    assert @rook.is_obstructed?(3, 7)
  end

  test 'Legal vertical move' do
    assert @rook.legal_move?(3, 5)
  end

  test 'Legal horizontal move' do
    assert @rook.legal_move?(7, 4)
  end

  test 'Legal move, captures opponent piece' do
    assert @rook.legal_move?(3, 6)
  end

  test 'Illegal diagonal move' do
    assert_not @rook.legal_move?(4, 5)
  end

  test 'Illegal obstructed move' do
    assert_not @rook.legal_move?(3, 7)
  end

  test 'Illegal move, own piece occupies square' do
    assert_not @rook.legal_move?(3, 1)
  end

  test 'Illegal move, not on board' do
    assert_not @rook.legal_move?(8, 4)
  end

  private

  def game_and_rook
    @game = Game.create(:name => 'lolomg', :white_player_id => 1)
    @rook = @game.pieces.create(
      type: 'Rook', 
      x_position: 3, 
      y_position: 4,
      player_id: 1)
  end
end