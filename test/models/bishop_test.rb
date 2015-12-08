require 'test_helper'

class BishopTest < ActiveSupport::TestCase
  setup :game_and_bishop

  test 'Illegal vertical move' do
    assert_not @bishop.legal_move?(3, 5)
  end

  test 'Illegal horizontal move' do
    assert_not @bishop.legal_move?(7, 4)
  end

  test 'Legal move, captures opponent piece' do
    assert @bishop.legal_move?(5, 6)
  end

  test 'Legal diagonal move' do
    assert @bishop.legal_move?(4, 5)
  end

  test 'Illegal obstructed move' do
    assert_not @bishop.legal_move?(6, 7)
  end

  test 'Illegal move, own piece occupies square' do
    assert_not @bishop.legal_move?(6, 1)
  end

  private

  def game_and_bishop
    @game = Game.create(:name => 'lolomg', :white_player_id => 1)
    @bishop = @game.pieces.create(
      type: 'Bishop', 
      x_position: 3, 
      y_position: 4,
      player_id: 1)
  end
end