class Piece < ActiveRecord::Base
  belongs_to :player, class_name: 'User'
  belongs_to :game

  def flat_position
  	#self.x_position + self.y_position * 8
    flat_destination(self.x_position, self.y_position)
  end

  def flat_destination(x,y)
  	x + y * 8
  end
  # Instead of calculating x + y * 8, Consider using a 2D array instead:
  # Coords = [[0,1,2,3,4,5,6,7],[8,9,10,11...]...[...60,61,62,63]]
  # Then call Coords[y][x]
  # Coords[0][0] => 0, Coords[3][5] => 29, Coords[7][7] => 63

  def distance_to(x,y)
  	[(self.x_position - x).abs, (self.y_position - y).abs].max
  end

  def vector_to(x,y)
  	unless self.distance_to(x,y) == 0
  		(self.flat_position - flat_destination(x,y))/self.distance_to(x,y)
  	end
  end

  def is_obstructed?(x,y)
  	self.game.pieces.any? do |piece|
  		self.vector_to(x,y) == self.vector_to(piece.x_position, piece.y_position) &&
  		self.distance_to(x,y) > self.distance_to(piece.x_position,piece.y_position)
  	end
  end
end
