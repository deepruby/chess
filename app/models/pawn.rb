class Pawn < Piece
  def legal_moves
    unobstructed_squares.select do |s|
      (forward_one?(s) && !occupied?(s)) ||
        (forward_two?(s) && !occupied?(s) && not_moved) ||
        (captures_diagonally?(s))
    end
  end

  def starting_rank
    color == 'White' ? 1 : 6
  end

  def not_moved
    y_position == starting_rank
  end

  private

  def advances?(square)
    color == 'White' ? square[1] > y_position : square[1] < y_position
  end

  def same_file?(square)
    square[0] == x_position
  end

  def forward_one?(square)
    advances?(square) &&
      same_file?(square) &&
      (square[1] - y_position).abs == 1
  end

  def forward_two?(square)
    advances?(square) &&
      same_file?(square) &&
      (square[1] - y_position).abs == 2
  end

  def captures_diagonally?(square)
    opponent_pieces = game.pieces.where.not(player_id: player_id)
    advances?(square) &&
      (square[1] - y_position).abs == 1 &&
      (square[0] - x_position).abs == 1 &&
      opponent_pieces.any? { |piece| piece.x_position == square[0] && piece.y_position == square[1] }
  end

  def occupied?(square)
    game.pieces.any? do |piece|
      piece.x_position == square[0] && piece.y_position == square[1]
    end
  end
end
