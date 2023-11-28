class Admin::OffersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_offer, only: [:edit, :update, :destroy]

  def index
    @admin_user = current_admin_user
    @offers = Offer.all
    @offers = @offers.where(status: params[:status]) if params[:status].present?
    @offers = @offers.page(params[:page]).per(6)
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      flash[:notice] = t('offer_created_successfully')
      redirect_to admin_offers_path
    else
      flash.now[:alert] = t('offer_create_failed')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @offer.update(offer_params)
      flash[:notice] = t('offer_updated_successfully')
      redirect_to admin_offers_path
    else
      flash.now[:alert] = t('offer_update_failed')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @offer.destroy
    flash[:notice] = t('offer_destroyed_successfully')
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
