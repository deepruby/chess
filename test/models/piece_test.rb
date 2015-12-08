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

  # test "knight cannot be obstructed" do
  #   runtime_error = assert_raises(RuntimeError) do
  #     @white_knight.is_obstructed?(1,4)
  #   end
  #   assert_equal("Invalid input. Not diagonal, horizontal, or vertical.", runtime_error.message)
  # end

  test "not obstructed piece in destination" do
    assert_not @white_rook.is_obstructed?(0,5)
  end

  test "not obstructed no piece in destination" do
    assert_not @white_rook.is_obstructed?(2,7)
  end

  test "capture - valid, opponent piece" do
    # white_bishop is at [0,5] from initialize_board
    @black_bishop.capture_opponent!(0,5)
    @white_bishop.reload
    assert_equal [nil,nil], [@white_bishop.x_position, @white_bishop.y_position]
  end

  test "capture - invalid, own piece" do
    # black_rook is at [0,0] from initialize_board
    @black_bishop.capture_opponent!(0,0)
    @black_rook.reload
    assert_equal [0,0], [@black_rook.x_position, @black_rook.y_position]
  end

  test "move - invalid" do
    @black_king.move!(4,2)
    @black_king.reload
    assert_equal [4,0], [@black_king.x_position, @black_king.y_position]
  end

  test "move - valid" do
    @black_king.update_attributes(:x_position => 4, :y_position => 2)
    @black_king.move!(4,3)
    @black_king.reload
    assert_equal [4,3], [@black_king.x_position, @black_king.y_position]
  end

  test "move - valid with capture" do
    @black_king.update_attributes(:x_position => 1, :y_position => 5)
    @black_king.move!(1,6)
    @black_king.reload
    @white_pawn2.reload
    assert_equal [1,6], [@black_king.x_position, @black_king.y_position]
    assert_equal [nil,nil], [@white_pawn2.x_position, @white_pawn2.y_position]
  end

  private

  def initialize_board
    @black_player = FactoryGirl.create(:user) 
    @white_player = FactoryGirl.create(:user) 

    # create a game and the 32 pieces, select pieces to test
    @game = Game.create(:name => 'lolomg', :black_player => @black_player, :white_player => @white_player)
    @black_bishop = @game.pieces.find{|piece| piece.x_position == 5 && piece.y_position == 0}
    @black_pawn = @game.pieces.find{|piece| piece.x_position == 2 && piece.y_position == 1}
    @black_rook = @game.pieces.find{|piece| piece.x_position == 0 && piece.y_position == 0}
    @black_king = @game.pieces.find{|piece| piece.x_position == 4 && piece.y_position == 0}
    @white_bishop = @game.pieces.find{|piece| piece.x_position == 2 && piece.y_position == 7}
    @white_knight = @game.pieces.find{|piece| piece.x_position == 1 && piece.y_position == 7}
    @white_rook = @game.pieces.find{|piece| piece.x_position == 0 && piece.y_position == 7}
    @white_pawn = @game.pieces.find{|piece| piece.x_position == 0 && piece.y_position == 6}
    @white_pawn2 = @game.pieces.find{|piece| piece.x_position == 1 && piece.y_position == 6}
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
