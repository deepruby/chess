class PiecesController < ApplicationController
  def edit
    @piece = Piece.find(params[:id])
    @game = @piece.game
	end

	def update
    @piece = Piece.find(params[:id])
    @game = @piece.game
    flash[:alert] = 'Not a valid move' if !@piece.move!(piece_params[:x_position].to_i, piece_params[:y_position].to_i)
    render nothing: true
	end

  private

  def piece_params
    params.require(:piece).permit(:x_position, :y_position)
  end
end
