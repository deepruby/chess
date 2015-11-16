class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.integer :x_position
      t.integer :y_position
      t.string :color
      t.integer :player_id
      t.integer :game_id
      t.string :type

      t.timestamps
    end
  end
end
