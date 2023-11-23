class Admin::TicketsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_ticket, only: :cancel

  def index
    @admin_user = current_admin_user
    @items = Item.all
    @client_users = User.where(role: "client")
    @tickets = Ticket.includes(:item, :user).all.page(params[:page]).per(8)

    @tickets = @tickets.where(users: { email: params[:email] }) if params[:email].present?
    @tickets = @tickets.where(items: { name: params[:name] }) if params[:name].present?
    @tickets = @tickets.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @tickets = @tickets.where(state: params[:state]) if params[:state].present?

    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @tickets = @tickets.where(created_at: start_date..end_date)
    end
  end

  def cancel
    @ticket.cancel! if @ticket.may_cancel?
    redirect_to admin_tickets_path
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end
end