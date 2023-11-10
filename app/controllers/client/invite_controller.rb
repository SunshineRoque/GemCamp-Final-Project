class Client::InviteController < ApplicationController
  include Devise::Controllers::Helpers

  def index
    @user = current_client_user
  end

end
