class King < Piece
  def legal_moves
    accessible_squares.select do |s|
      distance_to(s[0], s[1]) == 1
    end
  end

  def can_castle?(side) # enter either 'queen' or 'king'side
    if side == 'queen' || side == 'king'
      left_obstructed = game.pieces.where(x_position: [1, 2, 3], y_position: y_position)
      right_obstructed = game.pieces.where(x_position: [5, 6], y_position: y_position)
      left_rook = game.pieces.find_by(type: 'Rook', player_id: player_id, x_position: 0)
      right_rook = game.pieces.find_by(type: 'Rook', player_id: player_id, x_position: 7)

      can_castle = { 'queen' => false, 'king' => false }
      can_castle['queen'] = true if left_rook && !left_rook.moved && !moved && left_obstructed.empty? && !self.check?
      can_castle['king'] = true if right_rook && !right_rook.moved && !moved && right_obstructed.empty? && !self.check?
      can_castle[side]
    end
  end

  def castle!(side) # enter either 'queen' or 'king'side
    if side == 'queen' && can_castle?('queen')
      update_attributes(x_position: 2)
      left_rook = game.pieces.find_by(type: 'Rook', player_id: player_id, x_position: 0)
      left_rook.update_attributes(x_position: 3)
    end

    if side == 'king' && can_castle?('king')
      right_rook = game.pieces.find_by(type: 'Rook', player_id: player_id, x_position: 7)
      right_rook.update_attributes(x_position: 5)
      update_attributes(x_position: 6)
    end
  end

  def check?
    opponent_moves = []
    opponent_pieces = self.game.pieces.where.not(player_id: player_id)
    opponent_pieces.each do |piece|
      piece.legal_moves.each do |square|
          opponent_moves.push(square)
      end
    end

    opponent_moves.include?([self.x_position, self.y_position])
  end
end
