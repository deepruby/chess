class GamesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :index]

  def index
    @open_games = Game.where('black_player_id' => nil)
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)

    if @game.valid?
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.assign_attributes(:black_player_id => current_user.id)
    @game.save
    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:name, :white_player_id)
  end

end
