class Piece < ActiveRecord::Base
  belongs_to :player, class_name: 'User'
  belongs_to :game

  ##
  # In order to calculate the vectors, we essentially need to 
  # flatten the chess board, converting the position of the piece
  # from x,y coordinates to a number between 0 and 63. Since
  # the destination square of a move will be given in x,y coords,
  # we flatten that as well. 

  def flat_position
    flat_destination(self.x_position, self.y_position)
  end

  def flat_destination(x,y)
  	x + y * 8
  end

  ##
  # Calculate the number of squares a piece has to move to get to 
  # a destination. Treat diagonal moves the same as horizontal/vertical, 
  # i.e. 3 squares diagonally is the same 'distance' as 3 squares 
  # horizontally or vertically.

  def distance_to(x,y)
  	[(self.x_position - x).abs, (self.y_position - y).abs].max
  end

  ##
  # Vector_to yields a particular ratio, namely, the difference between
  # a piece's position and another square, divided by their distance 
  # from each other.  Prevent calculating the vector to a piece's own 
  # square, which would raise a ZeroDivisionError.

  def vector_to(x,y)
  	unless self.distance_to(x,y) == 0
  		(self.flat_position - flat_destination(x,y))/self.distance_to(x,y)
  	end
  end

  ##
  # In chess, all moves that can be obstructed have one of the 
  # following 8 vectors.

  LegalVectors = [-9, -8, -7, -1, 1, 7, 8, 9]

  ##
  # Calculate if a move is obstructed for a particular piece to a 
  # particular square. "Are there any pieces on the board that lie 
  # along the same vector as the move but that are closer to the piece 
  # than the destination square?"  Raise an exception if the move 
  # cannot be obstructed (a knight's move or illegal move)

  def is_obstructed?(x,y)
  	if LegalVectors.include?(self.vector_to(x,y))
	  	self.game.pieces.any? do |piece|
	  		self.vector_to(x,y) == self.vector_to(piece.x_position, piece.y_position) &&
	  		self.distance_to(x,y) > self.distance_to(piece.x_position,piece.y_position)
	  	end
	  else
	  	raise "Invalid input. Not diagonal, horizontal, or vertical."
	  end
  end
end
