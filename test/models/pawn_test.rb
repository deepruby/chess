require 'test_helper'

class PawnTest < ActiveSupport::TestCase
  setup :game_and_pawn

  test 'Pawn can advance 1 square' do
    assert @first_pawn.legal_move?(1, 2)
  end

  test 'Pawn that has not moved can advance 2 squares' do
    assert @first_pawn.legal_move?(1, 3)
  end

  test 'Pawn cannot move diagonally unless capturing' do
    assert_not @first_pawn.legal_move?(2, 2)
  end

  test 'Pawn can move diagonally if capturing' do
    @enemy_pawn = @game.pieces.create(
      type: 'Pawn',
      x_position: 2,
      y_position: 2,
      player_id: 2)
    assert @first_pawn.legal_move?(2, 2)
  end

  test 'Pawn that has moved can no longer advance 2 squares' do
    @second_pawn.move!(6, 2)
    assert_not @second_pawn.legal_move?(6, 4)
  end

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

  test 'Pawn cannot capture vertically' do
    assert_not @fourth_pawn.legal_move?(5, 5)
  end

  test 'Pawn just does not move like that' do
    assert_not @fourth_pawn.legal_move?(4, 4)
  end

  test 'Pawn starts with en passant flag nil' do
    game = Game.create(name: 'lolomg', white_player_id: 1, black_player_id: 2)
    white_pawn = game.pieces.find_by(x_position: 4, y_position: 1)
    assert_nil white_pawn.en_passant
  end

  test 'Pawn advances 2, en passant flag true' do
    game = Game.create(name: 'lolomg', white_player_id: 1, black_player_id: 2)
    white_pawn = game.pieces.find_by(x_position: 4, y_position: 1)
    white_pawn.move!(4, 3)
    assert white_pawn.en_passant
    assert white_pawn.x_position == 4 && white_pawn.y_position == 3
  end

  test 'Opponent moves, en passant resets to false' do
    game = Game.create(name: 'lolomg', white_player_id: 1, black_player_id: 2)
    white_pawn = game.pieces.find_by(x_position: 4, y_position: 1)
    white_pawn.move!(4, 3)
    assert white_pawn.en_passant
    black_pawn = game.pieces.find_by(x_position: 3, y_position: 6)
    black_pawn.move!(3, 4)
    white_pawn.reload
    assert_not white_pawn.en_passant
  end

  test 'En passant is legal move for pawn' do
    game = Game.create(name: 'lolomg', white_player_id: 1, black_player_id: 2)
    white_pawn = game.pieces.find_by(x_position: 4, y_position: 1)
    white_pawn.move!(4, 3)
    black_knight = game.pieces.find_by(x_position: 6, y_position: 7)
    black_knight.move!(5, 5)
    white_pawn.move!(4, 4)
    black_pawn = game.pieces.find_by(x_position: 3, y_position: 6)
    black_pawn.move!(3, 4)
    white_pawn.reload
    assert white_pawn.legal_move?(3, 5)
  end

  test 'En passant captures opponent pawn' do
    game = Game.create(name: 'lolomg', white_player_id: 1, black_player_id: 2)
    white_pawn = game.pieces.find_by(x_position: 4, y_position: 1)
    white_pawn.move!(4, 3)
    black_knight = game.pieces.find_by(x_position: 6, y_position: 7)
    black_knight.move!(5, 5)
    white_pawn.move!(4, 4)
    black_pawn = game.pieces.find_by(x_position: 3, y_position: 6)
    black_pawn.move!(3, 4)
    white_pawn.reload
    assert white_pawn.legal_move?(3, 5)
    white_pawn.move!(3, 5)
    white_pawn.reload
    black_pawn.reload
    assert_equal [3, 5], [white_pawn.x_position, white_pawn.y_position]
    assert_equal [nil, nil], [black_pawn.x_position, black_pawn.y_position]
  end

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
