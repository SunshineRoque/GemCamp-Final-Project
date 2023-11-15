class Client::LotteryController < ApplicationController
  before_action :skip_authentication, only: [:lottery]

  def index
    @user = current_client_user
    @categories = Category.all
    @selected_category = params[:category_id] ? Category.find(params[:category_id]) : nil
    @items = @selected_category ? @selected_category.items : Item.includes(:categories).all
  end

  def skip_authentication
    # Check if the user is signed in
    unless user_client_signed_in?
      # If not signed in, allow access to the lottery page
      return
    end

    # If the user is signed in, you might want to redirect them to another page
    # or handle the situation accordingly
    redirect_to root_path, notice: 'You are already signed in.'
  end
  def search
    @categories = Category.find_by(name: category_name)
    render client_lottery_index_path
  end
end