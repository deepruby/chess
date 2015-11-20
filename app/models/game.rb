class Game < ActiveRecord::Base
  has_many :pieces
  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'

  validates :name, presence: true
end
