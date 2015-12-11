class GamesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :join]

  def index
    if current_user
      @open_games = Game.where('black_player_id' => nil).where('white_player_id != ?', current_user.id)
    else
      @open_games = Game.where('black_player_id' => nil)
    end
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

  def join
    @game = Game.find(params[:id])
    if current_user.id == @game.white_player_id
      return render :text => 'Not Allowed', :status => :forbidden
    else
      @game.update_attributes(black_player_id: current_user.id)
      redirect_to game_path(@game)
    end
  end

  private

  def game_params
    params.require(:game).permit(:name, :white_player_id)
  end

end
