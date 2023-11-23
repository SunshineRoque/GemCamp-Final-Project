class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_order, only: [:cancel, :pay]

  def index
    @admin_user = current_admin_user
    @offers = Offer.all
    @client_users = User.where(role: "client")
    @orders = Order.includes(:offer, :user).all

    @orders = @orders.where(users: { email: params[:email] }) if params[:email].present?
    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
    @orders = @orders.where(offer: { name: params[:name] }) if params[:name].present?
    @name_options = Offer.pluck(:name).uniq


    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @orders = @orders.where(created_at: start_date..end_date)
    end
  end

  def pay
    @order.pay! if @order.may_pay?
    redirect_to admin_orders_path
  end

  def cancel
    @order.cancel! if @order.may_cancel?
    redirect_to admin_orders_path
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end