class Bishop < Piece
  def legal_moves
    unobstructed_squares.select do |s|
      (x_position - s[0]).abs == (y_position - s[1]).abs
    end
  end
end
