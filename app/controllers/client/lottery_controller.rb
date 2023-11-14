class Client::LotteryController < ApplicationController
  before_action :skip_authentication, only: [:lottery]

  def index
    @user = current_client_user
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
end