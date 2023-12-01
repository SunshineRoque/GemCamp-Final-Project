class Client::LotteryController < ApplicationController
  before_action :authenticate_client_user!, only: :create
  before_action :set_item, only: [:show]

  def index
    @user = current_client_user
    @categories = Category.all
    @selected_category = params[:category_id] ? Category.find(params[:category_id]) : nil
    @items = @selected_category ? @selected_category.items : Item.includes(:categories).all.page(params[:page]).per(10)
    @banners = Banner.where("online_at <= ? AND offline_at > ? AND status = ?", Time.current, Time.current, 'active')
    @news_tickers = NewsTicker.where("status = ?",'active').limit(5)
  end

  def show
    @ticket = Ticket.new
    @user = current_client_user
    @progress_percentage = (Ticket.where(batch_count: @item.batch_count).count.to_f / @item.minimum_tickets) * 100
    @tickets = Ticket.where(user_id: current_client_user.id, item_id: @item.id, batch_count: @item.batch_count).page(params[:page]).per(10)
  end

  def search
    @categories = Category.find_by(name: category_name)
    render client_lottery_index_path
  end

  def create
    quantity = params[:ticket][:quantity].to_i
    @item = Item.find(params[:ticket][:item_id])

    if quantity.positive? && current_client_user.coins >= quantity
      quantity.times do
        Ticket.create(item: @item, user: current_client_user)
      end
      flash[:notice] = t('successfully_bought', quantity: quantity)
      redirect_to client_lottery_path(@item)
    elsif quantity <= 0
      flash[:alert] = t('quantity_positive')
      redirect_to client_lottery_path(@item)
    else
      flash[:alert] = t("not_enough_coins")
      redirect_to client_shop_index_path
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(
      :user_id,
      :coins,
      :state
    )
  end
end