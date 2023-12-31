class Admin::HomeController < ApplicationController
  before_action :authenticate_admin_user!
  def index
    @admin_user = current_admin_user
    @client_users = User.where(role: "client").page(params[:page]).per(6)
  end
end
