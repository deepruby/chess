class Knight < Piece
	def legal_moves
		accessible_squares.select do |s|
			(x_position - s[0]).abs + (y_position - s[1]).abs == 3 &&
			x_position != s[0] && y_position != s[1]
		end
	end
end
