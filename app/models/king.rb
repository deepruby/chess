class King < Piece
	def legal_moves
		ALL_SQUARES.select do |s|
			distance_to(s[0],s[1]) == 1
		end
	end
end
