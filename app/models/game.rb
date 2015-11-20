class Game < ActiveRecord::Base
  has_many :pieces
  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'

  validates :name, presence: true

  after_create :populate_board!

  def populate_board!
		# White Pieces
    (0..7).each do |i|
      Pawn.create(
        game_id: id,
        x_position: i,
        y_position: 1,
        player_id: white_player
        )
    end

    Rook.create(game_id: id, x_position: 0, y_position: 0, player_id: white_player)
    Rook.create(game_id: id, x_position: 7, y_position: 0, player_id: white_player)

    Knight.create(game_id: id, x_position: 1, y_position: 0, player_id: white_player)
    Knight.create(game_id: id, x_position: 6, y_position: 0, player_id: white_player)

    Bishop.create(game_id: id, x_position: 2, y_position: 0, player_id: white_player)
    Bishop.create(game_id: id, x_position: 5, y_position: 0, player_id: white_player)

    Queen.create(game_id: id, x_position: 3, y_position: 0, player_id: white_player)
    King.create(game_id: id, x_position: 4, y_position: 0, player_id: white_player)

    # Black Pieces
    (0..7).each do |i|
      Pawn.create(
        game_id: id,
        x_position: i,
        y_position: 6,
        player_id: black_player
        )
    end

    Rook.create(game_id: id, x_position: 0, y_position: 7, player_id: black_player)
    Rook.create(game_id: id, x_position: 7, y_position: 7, player_id: black_player)

    Knight.create(game_id: id, x_position: 1, y_position: 7, player_id: black_player)
    Knight.create(game_id: id, x_position: 6, y_position: 7, player_id: black_player)

    Bishop.create(game_id: id, x_position: 2, y_position: 7, player_id: black_player)
    Bishop.create(game_id: id, x_position: 5, y_position: 7, player_id: black_player)

    Queen.create(game_id: id, x_position: 3, y_position: 7, player_id: black_player)
    King.create(game_id: id, x_position: 4, y_position: 7, player_id: black_player)

  end
end
