require 'test_helper'

class KingTest < ActiveSupport::TestCase
  setup :game_and_king

  test 'Legal vertical move' do
    assert @moves_king.legal_move?(4, 3)
  end

  test 'Legal diagonal move' do
    assert @moves_king.legal_move?(5, 3)
  end

  test 'Illegal move' do
    assert_not @moves_king.legal_move?(5, 4)
  end

  test 'Illegal move, not on board' do
    new_king = @game.pieces.create(
      type: 'King',
      x_position: 7,
      y_position: 3,
      player_id: 1)
    assert_not new_king.legal_move?(8, 3)
  end

  test 'can_castle? - true, queen side' do
    @white_queen.update_attributes(x_position: nil, y_position: nil)
    @left_knight.update_attributes(x_position: nil, y_position: nil)
    @left_bishop.update_attributes(x_position: nil, y_position: nil)
    assert_equal true, @white_king.can_castle?('queen')
  end

  test 'can_castle? - true, king side' do
    @right_knight.update_attributes(x_position: nil, y_position: nil)
    @right_bishop.update_attributes(x_position: nil, y_position: nil)
    assert_equal true, @white_king.can_castle?('king')
  end

  test 'can_castle? - false, obstructed' do
    @right_bishop.update_attributes(x_position: nil, y_position: nil)
    assert_equal false, @white_king.can_castle?('king')
  end

  test 'can_castle? - false, king moved' do
    @white_king.update_attributes(moved: true)
    assert_equal false, @white_king.can_castle?('king')
  end

  test 'can_castle? - false, rook moved' do
    @right_bishop.update_attributes(moved: true)
    assert_equal false, @white_king.can_castle?('king')
  end

  test 'castling - queen side' do
    @white_queen.update_attributes(x_position: nil, y_position: nil)
    @left_knight.update_attributes(x_position: nil, y_position: nil)
    @left_bishop.update_attributes(x_position: nil, y_position: nil)
    @white_king.castle!('queen')

    @white_king.reload
    @left_rook.reload
    assert_equal 2, @white_king.x_position
    assert_equal 3, @left_rook.x_position
  end

  test 'castling - king side' do
    @right_knight.update_attributes(x_position: nil, y_position: nil)
    @right_bishop.update_attributes(x_position: nil, y_position: nil)
    @white_king.castle!('king')

    @white_king.reload
    @right_rook.reload
    assert_equal 6, @white_king.x_position
    assert_equal 5, @right_rook.x_position
  end

  test 'castling - invalid' do
    @white_king.castle!('king')
    @white_king.reload
    @right_rook.reload
    assert_equal 4, @white_king.x_position
    assert_equal 7, @right_rook.x_position
  end

  test 'check? - false' do
    assert_equal false, @white_king.check?
  end

  test 'check? - true' do
    @black_queen.update_attributes(x_position: 4, y_position: 1)
    @white_pawn.update_attributes(x_position: nil, y_position: nil)
    assert_equal true, @white_king.check?
  end

  private

  def game_and_king
    @game = Game.create(name: 'lolomg', white_player_id: 1, black_player_id: 2)
    @moves_king = @game.pieces.create(type: 'King', x_position: 4, y_position: 2)
    @white_king = @game.pieces.find_by(type: 'King', player_id: 1)
    @white_queen = @game.pieces.find_by(type: 'Queen', player_id: 1)
    @black_queen = @game.pieces.find_by(type: 'Queen', player_id: 2)
    @left_rook = @game.pieces.find_by(type: 'Rook', player_id: 1, x_position: 0)
    @right_rook = @game.pieces.find_by(type: 'Rook', player_id: 1, x_position: 7)
    @left_knight = @game.pieces.find_by(type: 'Knight', player_id: 1, x_position: 1)
    @right_knight = @game.pieces.find_by(type: 'Knight', player_id: 1, x_position: 6)
    @left_bishop = @game.pieces.find_by(type: 'Bishop', player_id: 1, x_position: 2)
    @right_bishop = @game.pieces.find_by(type: 'Bishop', player_id: 1, x_position: 5)
    @white_pawn = @game.pieces.find_by(type: 'Pawn', player_id: 1, x_position: 4)
  end
end
