class Client::MeController < ApplicationController
  include Devise::Controllers::Helpers
  before_action :authenticate_client_user!
  before_action :set_user, only: :update
  before_action :set_winner, only: [:show, :update_winners]
  before_action :set_order, only: :cancel

  def index
    @user = current_client_user
    @orders = Order.includes(:offer, :user).where(user: current_client_user)
    @tickets = Ticket.includes(:item, :user).all
    @winners = Winner.includes(:item, :ticket, :user).all
    @client_users = User.where(role: "client")
  end

  def show
    @user = current_client_user
    @addresses = Address.includes(:user, :region, :province).where(user: current_client_user)
  end

  def update
    @user = current_client_user

    if @user.update(user_params)
      redirect_to client_me_index_path, notice: t('user_was_successfully_updated')
    else
      render :edit
    end
  end

  def update_winners
    @winner.address_id = params[:winner][:addresses_id]
    if @winner.save
      @winner.claim! if @winner.may_claim?
      flash[:notice] = t('prize_claimed_successfully')
      redirect_to client_me_index_path
    else
      puts "Errors: #{@winner.errors.full_messages}"
      flash.now[:alert] = t('prize_claim_failed')
      render :show, status: :unprocessable_entity
    end
  end

  def cancel
    @order.cancel! if @order.may_cancel?
    redirect_to client_me_index_path
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_winner
    @winner = Winner.find(params[:id])
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def user_params
    params.require(:address).permit(:email, :name)
  end

  def winner_params
    params.require(:winner).permit(:address_id)
  end
end
