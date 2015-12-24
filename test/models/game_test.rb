require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'correct number of pieces' do
    game = Game.create(name: 'yolo', white_player_id: 1)
    assert_equal game.pieces.count, 32
  end

  test 'white player should go first' do
  	game = Game.create(name: 'yolo', white_player_id: 1)
  	assert_equal game.turn, game.white_player_id
  end

  test 'black player is opponent at start of game' do
    game = Game.create(name: 'yolo', white_player_id: 1)
    assert_equal game.opponent, game.black_player_id
  end

  test 'turn changes after player moves' do
  	game = Game.create(name: 'yolo', white_player_id: 1)
    assert_equal game.turn, game.white_player_id
  	pawn = game.pieces.find_by(type: 'Pawn', player_id: 1)
  	pawn.move!(pawn.x_position, (pawn.y_position + 1))
  	game.reload
  	assert_equal game.turn, game.black_player_id
  end

  test 'player becomes opponent after move' do
    game = Game.create(name: 'yolo', white_player_id: 1)
    assert_equal game.opponent, game.black_player_id
    pawn = game.pieces.find_by(type: 'Pawn', player_id: 1)
    pawn.move!(pawn.x_position, (pawn.y_position + 1))
    game.reload
    assert_equal game.opponent, game.white_player_id
  end
end
