class King < Piece
	def legal_moves
		AllSquares.select do |s|
			distance_to(s[0],s[1]) == 1
		end
	end

	def legal_move?(x,y)
		legal_moves.include?([x, y])
	end
end
