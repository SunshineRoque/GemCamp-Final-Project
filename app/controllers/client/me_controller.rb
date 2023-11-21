class Client::MeController < ApplicationController
  include Devise::Controllers::Helpers
  before_action :authenticate_client_user!
  before_action :set_user, only: :update

  def index
    @user = current_client_user
  end

  def update
    @user = current_client_user # Assuming you have a method like this to get the current user

    if @user.update(user_params)
      # Handle successful update
      redirect_to client_me_index_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:address).permit(:email, :name)
  end
end
