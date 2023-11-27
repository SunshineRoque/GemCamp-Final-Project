class Admin::NewsTickersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_news_ticker, only: [:edit, :update, :destroy]

  def index
    @admin_user = current_admin_user
    @news_tickers = NewsTicker.includes(:admin).page(params[:page]).per(8)
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)
    @news_ticker.admin = current_admin_user
    if @news_ticker.save
      flash[:notice] = 'NewsTicker created successfully'
      redirect_to admin_news_tickers_path
    else
      flash.now[:alert] = 'NewsTicker create failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @news_ticker.update(news_ticker_params)
      flash[:notice] = 'NewsTicker updated successfully'
      redirect_to admin_news_tickers_path
    else
      flash.now[:alert] = 'NewsTicker update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @news_ticker.destroy
      flash[:notice] = 'NewsTicker destroyed successfully'
    end
    redirect_to admin_news_tickers_path
  end

  private

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end

  def news_ticker_params
    params.require(:news_ticker).permit(
      :content,
      :status,)
  end
end
