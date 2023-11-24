class Client::ShareController < ApplicationController
  before_action :set_winner, only: [:show, :update]
  before_action :authenticate_client_user!, except: [:index]

  def index
    @user = current_client_user
    @winners = Winner.includes(:item).where(state: 'published')
  end

  def show
    @user = current_client_user
  end

  def update
    @winner.comment = params[:winner][:comment]
    @winner.picture = params[:winner][:picture]

    if @winner.save
      @winner.share! if @winner.may_share?
      flash[:notice] = 'Prize Shared successfully'
      redirect_to client_me_index_path
    else
      puts "Errors: #{@winner.errors.full_messages}"
      flash.now[:alert] = 'Prize Share failed'
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end

  def winner_params
    params.require(:winner).permit(:comment, :picture)
  end
end
