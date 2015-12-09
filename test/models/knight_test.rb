require 'test_helper'

class KnightTest < ActiveSupport::TestCase
  setup :game_and_knight

  test 'Illegal vertical move' do
    assert_not @knight.legal_move?(3, 2)
  end

  test 'Illegal horizontal move' do
    assert_not @knight.legal_move?(0, 3)
  end

  test 'Legal move, captures opponent piece' do
    assert @knight.legal_move?(4, 5)
  end

  test 'Illegal diagonal move' do
    assert_not @knight.legal_move?(2, 2)
  end

  test 'Legal move, knight cannot be obstructed' do
    assert @knight.legal_move?(4, 5)
  end

  test 'Illegal move, own piece occupies square' do
    assert_not @knight.legal_move?(4, 1)
  end

  test 'Illegal move for all piece types' do
    assert_not @knight.legal_move?(7, 5)
  end

  private

  def game_and_knight
    @game = Game.create(name: 'lolomg', white_player_id: 1)
    @knight = @game.pieces.create(
      type: 'Knight',
      x_position: 3,
      y_position: 3,
      player_id: 1)
    @black_pawn = @game.pieces.create(
      type: 'Pawn',
      x_position: 4,
      y_position: 5,
      player_id: 2)
    @white_pawn_1 = @game.pieces.create(
      type: 'Pawn',
      x_position: 3,
      y_position: 4,
      player_id: 1)
    @white_pawn_2 = @game.pieces.create(
      type: 'Pawn',
      x_position: 4,
      y_position: 4,
      player_id: 1)
    @white_pawn_3 = @game.pieces.create(
      type: 'Pawn',
      x_position: 4,
      y_position: 3,
      player_id: 1)
  end
end
