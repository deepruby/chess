require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "correct number of pieces" do
  	game = Game.create(:name => 'yolo', :white_player_id => 1)
    assert_equal game.pieces.count, 32
  end
end
