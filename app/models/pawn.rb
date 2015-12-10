class Pawn < Piece
  def legal_moves
    unobstructed_squares.select do |s|
      # Must advance
      color == "White" ? s[1] > y_position : s[1] < y_position
    end
  end

  def starting_rank
    color == "White" ? 1 : 6
  end

  def has_not_moved
    y_position == starting_rank
  end
end
