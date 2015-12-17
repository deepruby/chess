class Game < ActiveRecord::Base
  has_many :pieces
  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'

  validates :name, presence: true

  after_create :populate_board!

  def check?(player_id)
    opponent_moves = []
    opponent_pieces = self.pieces.where.not(player_id: player_id)
    opponent_pieces.each do |piece|
      piece.legal_moves.each do |square|
        opponent_moves.push(square)
      end
    end

    king = self.pieces.find_by(type: 'King', player_id: player_id)
    opponent_moves.include?([king.x_position, king.y_position])
  end

  private

  def populate_board!
    if pieces.empty?
      # White Pieces
      (0..7).each do |i|
        Pawn.create(
          game_id: id,
          x_position: i,
          y_position: 1,
          player_id: white_player_id
          )
      end

      Rook.create(game_id: id, x_position: 0, y_position: 0, player_id: white_player_id)
      Rook.create(game_id: id, x_position: 7, y_position: 0, player_id: white_player_id)

      Knight.create(game_id: id, x_position: 1, y_position: 0, player_id: white_player_id)
      Knight.create(game_id: id, x_position: 6, y_position: 0, player_id: white_player_id)

      Bishop.create(game_id: id, x_position: 2, y_position: 0, player_id: white_player_id)
      Bishop.create(game_id: id, x_position: 5, y_position: 0, player_id: white_player_id)

      Queen.create(game_id: id, x_position: 3, y_position: 0, player_id: white_player_id)
      King.create(game_id: id, x_position: 4, y_position: 0, player_id: white_player_id)

      # Black Pieces
      (0..7).each do |i|
        Pawn.create(
          game_id: id,
          x_position: i,
          y_position: 6,
          player_id: black_player_id
        )
      end

      Rook.create(game_id: id, x_position: 0, y_position: 7, player_id: black_player_id)
      Rook.create(game_id: id, x_position: 7, y_position: 7, player_id: black_player_id)

      Knight.create(game_id: id, x_position: 1, y_position: 7, player_id: black_player_id)
      Knight.create(game_id: id, x_position: 6, y_position: 7, player_id: black_player_id)

      Bishop.create(game_id: id, x_position: 2, y_position: 7, player_id: black_player_id)
      Bishop.create(game_id: id, x_position: 5, y_position: 7, player_id: black_player_id)

      Queen.create(game_id: id, x_position: 3, y_position: 7, player_id: black_player_id)
      King.create(game_id: id, x_position: 4, y_position: 7, player_id: black_player_id)
    else
      flash[:notice] = 'An error has occured.'
      redirect_to root_path
    end
  end
end
