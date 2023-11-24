class Client::CashInController < ApplicationController
  before_action :authenticate_client_user!
  before_action :set_user

  def edit; end

  def update
    # Assuming @user is set elsewhere in your controller
    @user.coins = params[:user][:coins]

    if @user.coins.to_i >= @user.coins_was.to_i
      if @user.save
        flash[:notice] = 'Cash In successfully'
        redirect_to client_me_index_path
      else
        puts "Errors: #{user.errors.full_messages}"
        flash.now[:alert] = 'Cash In failed'
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = 'The input number should be equal or greater than the current coins. Please try again.'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:address).permit(:coins)
  end

end
