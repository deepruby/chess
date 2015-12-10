require 'test_helper'

class PawnTest < ActiveSupport::TestCase
  setup :game_and_pawn

  test 'Pawn can advance 1 square' do
    assert @first_pawn.legal_move?(1, 2)
  end

  test 'Pawn that has not moved can advance 2 squares' do
    assert @first_pawn.legal_move?(1, 3)
  end

  # test 'Pawn cannot move diagonally unless capturing' do
  #   assert_not @first_pawn.legal_move?(2, 2)
  # end

  test 'Pawn can move diagonally if capturing' do
    @enemy_pawn = @game.pieces.create(
      type: 'Pawn',
      x_position: 2,
      y_position: 2,
      player_id: 2)
    assert @first_pawn.legal_move?(2, 2)
  end

  # test 'Pawn that has moved can no longer advance 2 squares' do
  #   @second_pawn.move!(6, 2)
  #   assert_not @second_pawn.legal_move?(6, 4)
  # end

  test 'Black pawns advance down the file' do
    assert @third_pawn.legal_move?(2, 5)
  end

  test 'Black pawns cannot move back up the file' do
    @third_pawn.move!(2, 4)
    assert_not @third_pawn.legal_move?(2, 5)
  end

  test 'Pawn cannot advance 2 squares if obstructed' do
    assert_not @fourth_pawn.legal_move?(5, 4)
  end

  # test 'Pawn cannot capture vertically' do
  #   assert_not @fourth_pawn.legal_move?(5, 5)
  # end

  private

  def game_and_pawn
    @game = Game.create(name: 'lolomg', white_player_id: 1, black_player_id: 2)
    @first_pawn = @game.pieces.find { |p| p.x_position == 1 && p.y_position == 1 }
    @second_pawn = @game.pieces.find { |p| p.x_position == 6 && p.y_position == 1 }
    @third_pawn = @game.pieces.find { |p| p.x_position == 2 && p.y_position == 6 }
    @fourth_pawn = @game.pieces.find { |p| p.x_position == 5 && p.y_position == 6 }
    @fifth_pawn = @game.pieces.create(
      type: 'Pawn',
      x_position: 5,
      y_position: 5,
      player_id: 1)
  end
end
