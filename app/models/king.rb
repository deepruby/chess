class King < Piece
	def legal_moves
		accessible_squares.select do |s|
			distance_to(s[0],s[1]) == 1
		end
	end
end
