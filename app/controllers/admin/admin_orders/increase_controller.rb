class Admin::AdminOrders::IncreaseController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_user, only: [:new, :create]

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user = @user
    @order.amount = 0
    @order.genre = 'increase'

    if @order.coin.to_i >= 0
      if @order.save
        @order.submit!
        @order.pay!
        flash[:notice] = 'Order was successfully created and paid'
        redirect_to admin_root_path
      else
        flash.now[:alert] = 'Order create failed'
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = 'The input number should be equal or greater 0. Please try again.'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def order_params
    params.require(:order).permit(:coin, :remarks)
  end
end