class Client::MenuController < ApplicationController
  def index
    @user = current_client_user
  end
end