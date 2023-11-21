class Admin::OffersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_offer, only: [:edit, :update, :destroy]

  def index
    @admin_user = current_admin_user
    @offers = Offer.all
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      flash[:notice] = 'Offer created successfully'
      redirect_to admin_offers_path
    else
      flash.now[:alert] = 'Offer create failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @offer.update(offer_params)
      flash[:notice] = 'Offer updated successfully'
      redirect_to admin_offers_path
    else
      flash.now[:alert] = 'Offer update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @offer.destroy
    flash[:notice] = 'Offer destroyed successfully'
    redirect_to admin_offers_path
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(
      :image,
      :name,
      :coin,
      :amount,
      :status)
  end
end
