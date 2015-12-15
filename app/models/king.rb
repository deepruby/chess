class King < Piece

  def legal_moves
    accessible_squares.select do |s|
      distance_to(s[0],s[1]) == 1
    end
  end

  def can_castle?(side) # enter either 'queen' or 'king'side
    if side == 'queen' || 'king'
      left_obstructed = self.game.pieces.where(x_position: [1,2,3], y_position: self.y_position)
      right_obstructed = self.game.pieces.where(x_position: [5,6], y_position: self.y_position)
      left_rook = self.game.pieces.find_by(type: 'Rook', player_id: self.player_id, x_position: 0)
      right_rook = self.game.pieces.find_by(type: 'Rook', player_id: self.player_id, x_position: 7)

      can_castle = {'queen' => false, 'king' => false}
      can_castle['queen'] = true if left_rook && !left_rook.moved && !self.moved && left_obstructed.empty? && !self.game.check?
      can_castle['king'] = true if right_rook && !right_rook.moved && !self.moved && right_obstructed.empty? && !self.game.check?
      can_castle[side]
    end
  end

  def castle!(side) # enter either 'queen' or 'king'side
    if side == 'queen' && can_castle?('queen')
      self.update_attributes(x_position: 2)
      left_rook = self.game.pieces.find_by(type: 'Rook', player_id: self.player_id, x_position: 0)
      left_rook.update_attributes(x_position: 3)
    end

    if side == 'king' && can_castle?('king')
      right_rook = self.game.pieces.find_by(type: 'Rook', player_id: self.player_id, x_position: 7)
      right_rook.update_attributes(x_position: 5)
      self.update_attributes(x_position: 6)
    end
  end
end
