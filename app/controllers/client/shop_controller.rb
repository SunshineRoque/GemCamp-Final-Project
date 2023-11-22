class Client::ShopController < ApplicationController
  before_action :authenticate_client_user!, only: :create
  before_action :set_offer, only: :show

  def index
    @user = current_client_user
    @offers = Offer.all
  end

  def show
    @order = Order.new
    @user = current_client_user
  end

  def create
    @offer = Offer.find(params[:order][:offer_id])
    @order = Order.new # Initialize a new order instance
    @order.user = current_client_user

    @order.coin = @offer.coin
    @order.amount = @offer.amount
    @order.offer = @offer


    if @order.save
      flash[:notice] = 'Order created successfully'
      redirect_to client_shop_index_path(@order) # Redirect after successfully saving the order
    else
      flash.now[:alert] = 'Order create failed'
      render :show # Render the new action or form again for corrections
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end
end