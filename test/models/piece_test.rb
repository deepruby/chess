require 'test_helper'

class PieceTest < ActiveSupport::TestCase
  setup :initialize_board

  test "white bishop is not obstructed" do
    assert_not @white_bishop.is_obstructed?(2,3)
  end

  test "black bishop is obstructed" do
    assert @black_bishop.is_obstructed?(3,2)
  end

  test "black rook is obstructed" do
    assert @black_rook.is_obstructed?(0,3)
  end

  test "knight cannot be obstructed" do
    runtime_error = assert_raises(RuntimeError) do
      @white_knight.is_obstructed?(1,4)
    end
    assert_equal("Invalid input. Not diagonal, horizontal, or vertical.", runtime_error.message)
  end

  test "not obstructed piece in destination" do
    assert_not @white_rook.is_obstructed?(0,5)
  end

  test "not obstructed no piece in destination" do
    assert_not @white_rook.is_obstructed?(2,7)
  end

  private

  def initialize_board
    # create a game and the 32 pieces, select pieces to test
    @game = Game.create(:name => 'lolomg')
    @black_bishop = @game.pieces.find{|piece| piece.x_position == 5 && piece.y_position == 0}
    @black_pawn = @game.pieces.find{|piece| piece.x_position == 2 && piece.y_position == 1}
    @black_rook = @game.pieces.find{|piece| piece.x_position == 0 && piece.y_position == 0}
    @white_bishop = @game.pieces.find{|piece| piece.x_position == 2 && piece.y_position == 7}
    @white_knight = @game.pieces.find{|piece| piece.x_position == 1 && piece.y_position == 7}
    @white_rook = @game.pieces.find{|piece| piece.x_position == 0 && piece.y_position == 7}
    @white_pawn = @game.pieces.find{|piece| piece.x_position == 0 && piece.y_position == 6}
    # remove the pawn at A7 from the board
    @white_pawn.destroy
    # move the bishop from C8 to A6 
    @white_bishop.update_attributes(:x_position => 0, :y_position => 5)
    # move the knight from B8 to D4
    @white_knight.update_attributes(:x_position => 3, :y_position => 3)
    # move the pawn from C2 to C4
    @black_pawn.update_attributes(:x_position => 2, :y_position => 3)
  end
end
