class Admin::BannersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_banner, only: [:edit, :update, :destroy]

  def index
    @admin_user = current_admin_user
    @banners = Banner.all.page(params[:page]).per(8)
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      flash[:notice] = 'Banner created successfully'
      redirect_to admin_banners_path
    else
      flash.now[:alert] = 'Banner create failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @banner.update(banner_params)
      flash[:notice] = 'Banner updated successfully'
      redirect_to admin_banners_path
    else
      flash.now[:alert] = 'Banner update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @banner.destroy
      flash[:notice] = 'Banner destroyed successfully'
    end
    redirect_to admin_banners_path
  end


  private

  def set_banner
    @banner = Banner.find(params[:id])
  end

  def banner_params
    params.require(:banner).permit(
      :preview,
      :online_at,
      :offline_at,
      :status,)
  end
end
