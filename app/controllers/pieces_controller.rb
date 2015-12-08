class PiecesController < ApplicationController
	def edit
    @piece = Piece.find(params[:id])
    @game = @piece.game
	end

	def update
    @piece = Piece.find(params[:id])
    @game = @piece.game
    @piece.update_attributes(:x_position => params[:x_position],
    	:y_position => params[:y_position])
    redirect_to game_path(@game)
	end
end
