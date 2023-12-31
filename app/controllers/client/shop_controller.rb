class Client::ShopController < ApplicationController
  before_action :authenticate_client_user!, only: :create
  before_action :set_offer, only: :show

  def index
    @user = current_client_user
    @offers = Offer.all.page(params[:page]).per(10)
    @banners = Banner.where("online_at <= ? AND offline_at > ? AND status = ?", Time.current, Time.current, 'active')
    @news_tickers = NewsTicker.where("status = ?",'active').limit(5)
  end

  def show
    @order = Order.new
    @user = current_client_user
  end

  def create
    @offer = Offer.find(params[:order][:offer_id])
    @order = Order.new
    @order.user = current_client_user
    @order.coin = @offer.coin
    @order.amount = @offer.amount
    @order.offer = @offer
    @order.state = 'submitted'

    if current_client_user.coins >= @offer.coin
      if @order.save
        flash[:notice] = t('order_created_successfully')
        redirect_to client_shop_index_path(@order)
      else
        flash.now[:alert] = t('order_create_failed')
        @user = current_client_user
        render :show
      end
    else
      flash.now[:alert] = t("you_dont_have_enough_coins")
      @user = current_client_user
      render :show
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end
end