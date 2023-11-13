class Client::HomeController < ApplicationController
  before_action :authenticate_client_user!

  def index
    @user = current_client_user
  end
end
