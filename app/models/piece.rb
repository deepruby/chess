class Piece < ActiveRecord::Base
  belongs_to :player, class_name: 'User'
  belongs_to :game

  ALL_SQUARES = [
    [0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], 
    [1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], 
    [2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7], 
    [3, 0], [3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7], 
    [4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [4, 7], 
    [5, 0], [5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6], [5, 7], 
    [6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7], 
    [7, 0], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7]
  ]
  
  def legal_move?(x,y)
    legal_moves.include?([x, y])
  end

  def color
    player_id == game.white_player_id ? "White" : "Black"
  end

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

  LEGAL_VECTORS = [-9, -8, -7, -1, 1, 7, 8, 9]

  ##
  # Calculate if a move is obstructed for a particular piece to a 
  # particular square. "Are there any pieces on the board that lie 
  # along the same vector as the move but that are closer to the piece 
  # than the destination square?"  Raise an exception if the move 
  # cannot be obstructed (a knight's move or illegal move)

  def is_obstructed?(x,y)
  	if LEGAL_VECTORS.include?(self.vector_to(x,y))
	  	self.game.pieces.any? do |piece|
	  		self.vector_to(x,y) == self.vector_to(piece.x_position, piece.y_position) &&
	  		self.distance_to(x,y) > self.distance_to(piece.x_position,piece.y_position)
	  	end
	  else
	  	raise "Invalid input. Not diagonal, horizontal, or vertical."
	  end
  end

  ##
  # Check for a valid unobstructed move
  # Check and capture opponent's piece if there is
  # Move the actual piec

  def move!(x,y)
    if self.legal_move?(x,y)
      self.capture_opponent!(x,y)
      self.update_attributes(x_position: x, y_position: y, moved: true)
    end
  end

  ##
  # Find an opponent piece in the particular square (distination)
  # "Capture" the piece if found by setting x, y position to nil
  
  def capture_opponent!(x,y)
    opponent_piece = self.game.pieces.where.not(player_id: self.player_id).where(x_position: x, y_position: y).first
    opponent_piece.update_attributes(x_position: nil, y_position: nil) if opponent_piece 
  end
end
