class RemoveColorFromPieces < ActiveRecord::Migration
  def change
    remove_column :pieces, :color, :string
  end
end
