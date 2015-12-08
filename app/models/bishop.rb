class Bishop < Piece
	def legal_moves
		accessible_squares.reject{|s| is_obstructed?(s[0],s[1])}.select do |s|
			(x_position - s[0]).abs == (y_position - s[1]).abs
		end
	end
end
