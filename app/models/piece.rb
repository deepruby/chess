class Piece < ActiveRecord::Base
  belongs_to :player, class_name: 'User'
  belongs_to :game

  def flat_position
  	self.x_position + self.y_position * 8
  end

  def flat_destination(x,y)
  	x + y * 8
  end

  def distance_to(x,y)
  	[(self.x_position - x).abs, (self.y_position - y).abs].max
  end

  def vector_to(x,y)
  	unless self.distance_to(x,y) == 0
  		(self.flat_position - flat_destination(x,y))/self.distance_to(x,y)
  	end
  end

  def is_obstructed?(x,y)
  	if [-9, -8, -7, -1, 1, 7, 8, 9].include?(self.vector_to(x,y))
	  	self.game.pieces.any? do |piece|
	  		self.vector_to(x,y) == self.vector_to(piece.x_position, piece.y_position) &&
	  		self.distance_to(x,y) > self.distance_to(piece.x_position,piece.y_position)
	  	end
	  else
	  	raise "Invalid input. Not diagonal, horizontal, or vertical."
	  end
  end
end
