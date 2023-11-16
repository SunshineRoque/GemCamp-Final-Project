class Client::LotteryController < ApplicationController
  before_action :skip_authentication, only: [:lottery, :show]
  before_action :set_item, only: :show

  def index
    @user = current_client_user
    @categories = Category.all
    @selected_category = params[:category_id] ? Category.find(params[:category_id]) : nil
    @items = @selected_category ? @selected_category.items : Item.includes(:categories).all
  end

  def show
    @user = current_client_user
  end

  def skip_authentication
    # Check if the user is signed in
    unless client_user_signed_in?
      # If not signed in, allow access to the lottery page
      return
    end

    # If the user is signed in, you might want to redirect them to another page
    # or handle the situation accordingly
    redirect_to client_lottery_index_path, notice: 'You are already signed in.'
  end
  def search
    @categories = Category.find_by(name: category_name)
    render client_lottery_index_path
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end
end