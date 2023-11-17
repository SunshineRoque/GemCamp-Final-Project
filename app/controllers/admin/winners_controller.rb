class Admin::WinnersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_winner, only: [:claim, :pay, :submit, :ship,:deliver, :share, :publish, :remove_publish]

  def index
    @admin_user = current_admin_user
    @items = Item.all
    @client_users = User.where(role: "client")
    @winners = Ticket.all
    @winners = Winner.includes(:item, :user, :ticket).all

    @winners = @winners.where(ticket: { serial_number: params[:serial_number]}) if params[:serial_number].present?
    @winners = @winners.where(users: { email: params[:email] }) if params[:email].present?
    @winners = @winners.where(state: params[:state]) if params[:state].present?

    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @winners = @winners.where(created_at: start_date..end_date)
    end
  end

  def claim
    @winner.claim! if @winner.may_claim?
    redirect_to admin_winners_path
  end

  def submit

    @winner.submit! if @winner.may_submit?
    redirect_to admin_winners_path
  end

  def pay

    @winner.pay! if @winner.may_pay?
    redirect_to admin_winners_path
  end

  def ship

    @winner.ship! if @winner.may_ship?
    redirect_to admin_winners_path
  end

  def deliver
    @winner.deliver! if @winner.may_deliver?
    redirect_to admin_winners_path
  end

  def publish

    @winner.publish! if @winner.may_publish?
    redirect_to admin_winners_path
  end

  def share

    @winner.share! if @winner.may_share?
    redirect_to admin_winners_path
  end

  def remove_publish

    @winner.remove_publish! if @winner.may_remove_publish?
    redirect_to admin_winners_path
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end

end