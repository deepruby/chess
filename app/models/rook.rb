class Rook < Piece
  def legal_moves
    unobstructed_squares.select do |s|
      x_position == s[0] || y_position == s[1]
    end
  end
end
