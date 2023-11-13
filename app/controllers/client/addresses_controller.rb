class Client::AddressesController < ApplicationController
  before_action :authenticate_client_user!
  before_action :set_address, only: [:show, :edit, :update, :destroy]

  def index
    @user = current_client_user
    @addresses = Address.includes(:user, :region, :province)
  end

  def new
    @user = current_client_user
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user = current_client_user
    if @address.save
      flash[:notice] = 'Address created successfully'
      redirect_to client_addresses_path
    else
      flash.now[:alert] = 'Address create failed'
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit
  end

  def update
    if @address.update(address_params)
      flash[:notice] = 'Address updated successfully'
      redirect_to client_addresses_path
    else
      flash.now[:alert] = 'Address update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    flash[:notice] = 'Address destroyed successfully'
    redirect_to client_addresses_path
  end

  private

  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(
      :street_address,
      :user_id,
      :region_id,
      :province_id,
      :city_id,
      :barangay_id,
      :genre,
      :name,
      :phone_number,
      :remark,
      :is_default
    )
  end
end