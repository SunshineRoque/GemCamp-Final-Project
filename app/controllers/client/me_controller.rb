class Client::MeController < ApplicationController
  include Devise::Controllers::Helpers
  before_action :authenticate_client_user!

  def index
    @user = current_client_user
  end

end
