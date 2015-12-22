class PiecesController < ApplicationController
  def edit
    @piece = Piece.find(params[:id])
    @game = @piece.game
	end

	def update
    @piece = Piece.find(params[:id])
    @game = @piece.game
    @piece.update_attributes(piece_params)
    render nothing: true
	end

  private

  def piece_params
    params.require(:piece).permit(:x_position, :y_position)
  end
end
